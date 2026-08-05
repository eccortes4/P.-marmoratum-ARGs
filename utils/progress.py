from pathlib import Path
import re
import time

dir_path = Path('/space/s1/eccortes/frogs/beagle_55_out/')

num_completed = 0

while num_completed < 17531:
    files = [str(f) for f in dir_path.iterdir() if f.is_file() and re.search(r"\.vcf.gz$", str(f))]
    num_completed = len(files)
    print(f"{num_completed}/17531 scaffolds called and imputed")
    print(f"{(num_completed/17531)*100:.2f}% complete")
    time.sleep(90)