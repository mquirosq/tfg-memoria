        contigs = output_dir / "contigs.fasta"
        cmd = ["raven", "-t", str(threads), reads_path]
        try:
            with open(contigs, "wb") as w:
                result = subprocess.run(cmd, check=True, stdout=w, stderr=subprocess.PIPE, text=True)
                if result.stderr:
                    append_job_log(job_id, f"[RAVEN STDERR] {result.stderr[:500]}")
        except subprocess.CalledProcessError as e:
            error_msg = f"Raven failed with code {e.returncode}\nSTDERR: {e.stderr or 'No stderr'}"
            raise RuntimeError(error_msg) from e