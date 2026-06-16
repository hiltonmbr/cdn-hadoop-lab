"""Shared HDFS utilities for notebooks.

Usage:
    import sys; sys.path.insert(0, '../scripts')
    from hdfs_utils import hadoop, block_report, compose, docker_cp, safe_delete, download_stream
"""

import os
import subprocess
import requests


def hadoop(cmd: str, container: str = 'namenode', timeout: int = 900) -> str:
    """Run a shell command inside a cluster container and return its stdout.

    Used for operations the WebHDFS proxy does not expose: fsck, dfsadmin,
    yarn jobs. Falls back to printing the command if `docker` is unreachable.
    """
    try:
        p = subprocess.run(['docker', 'exec', container, 'bash', '-lc', cmd],
                           capture_output=True, text=True, timeout=timeout)
    except (FileNotFoundError, subprocess.TimeoutExpired) as e:
        print(f'\u26a0\ufe0f  Could not run docker exec ({e}).')
        print(f'    Run manually inside `make shell-{container}`:\n    {cmd}')
        return ''
    if p.returncode != 0:
        print(f'\u26a0\ufe0f  Exit {p.returncode}. stderr tail:\n{p.stderr[-2000:]}')
    return p.stdout + p.stderr


def block_report(client, hdfs_path: str, proxy_url: str = 'http://localhost:14000') -> list | None:
    """Show how an HDFS file is split into blocks and where each replica lives.

    Uses the WebHDFS GETFILEBLOCKLOCATIONS operation through the HttpFS proxy.
    Returns the block list or None if unavailable.
    """
    st = client.status(hdfs_path)
    print(f"{hdfs_path}")
    print(f"  size={st['length']:,} bytes | blockSize={st['blockSize']:,} | "
          f"replication={st['replication']}")
    try:
        r = requests.get(f'{proxy_url}/webhdfs/v1{hdfs_path}',
                         params={'op': 'GETFILEBLOCKLOCATIONS', 'user.name': 'root'},
                         timeout=30)
        r.raise_for_status()
        blocks = r.json()['BlockLocations']['BlockLocation']
    except Exception as e:
        print(f'  (block locations unavailable via proxy: {e})')
        print('   \u2192 browse them visually at http://localhost:9870 \u2192 Utilities \u2192 Browse')
        return None
    print(f"  \u2192 {len(blocks)} block(s):")
    for i, b in enumerate(blocks):
        print(f"     block {i}: offset={b['offset']:>10,} len={b['length']:>10,} "
              f"replicas on {b['hosts']}")
    return blocks


def compose(cmd: str, compose_file: str = '../docker-compose.yml') -> str:
    """Run a docker compose command from the project root."""
    try:
        p = subprocess.run(
            ['docker', 'compose', '-f', compose_file] + cmd.split(),
            capture_output=True, text=True, timeout=120)
        return (p.stdout + p.stderr).strip()
    except (FileNotFoundError, subprocess.TimeoutExpired) as e:
        return f'\u26a0\ufe0f  Run manually: docker compose {cmd}  ({e})'


def docker_cp(local: str, dest: str, container: str = 'namenode'):
    """Copy a local file into a container."""
    subprocess.run(['docker', 'exec', container, 'mkdir', '-p',
                    dest.rsplit('/', 1)[0]], capture_output=True)
    subprocess.run(['docker', 'cp', local, f'{container}:{dest}'], check=True)


def safe_delete(client, hdfs_path: str):
    """Delete an HDFS path if it exists (idempotent)."""
    try:
        client.delete(hdfs_path, recursive=True)
    except Exception:
        pass


def download_stream(url: str, dest: str, chunk: int = 1024 * 1024, timeout: int = 300) -> int:
    """Stream a URL to a local file in chunks. Skips if already cached. Returns bytes written."""
    if os.path.exists(dest):
        size = os.path.getsize(dest)
        print(f'  cached: {dest} ({size / 1e6:.1f} MB)')
        return size
    with requests.get(url, stream=True, timeout=timeout) as r:
        r.raise_for_status()
        written = 0
        os.makedirs(os.path.dirname(dest) or '.', exist_ok=True)
        with open(dest, 'wb') as fh:
            for part in r.iter_content(chunk_size=chunk):
                fh.write(part)
                written += len(part)
    print(f'  downloaded: {dest} ({written / 1e6:.1f} MB)')
    return written
