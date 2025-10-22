import re
import random

# Load dictionary (replace with "words.txt" if you want your own list)
with open("/usr/share/dict/words") as f:
    WORDS = [w for w in f.read().splitlines() if w.isalpha()]

used_words = set()


def random_word(lower=True):
    """Return a unique random word from the dictionary."""
    while True:
        word = random.choice(WORDS)
        if lower:
            word = word.lower()
        else:
            word = word.upper()
        if word not in used_words:
            used_words.add(word)
            return word


def random_let_name():
    return random_word(lower=True)


def random_const_name():
    return random_word(lower=False)


def find_variable_names(code):
    let_matches = re.findall(r'\blet\s+mut\s+([a-zA-Z_][a-zA-Z0-9_]*)|\blet\s+([a-zA-Z_][a-zA-Z0-9_]*)', code)
    const_matches = re.findall(r'\bconst\s+([A-Z_][A-Z0-9_]*)\s*:', code)

    let_vars = {var for group in let_matches for var in group if var}
    const_vars = set(const_matches)

    return let_vars, const_vars


def replace_variables(code, var_map):
    for original in sorted(var_map.keys(), key=len, reverse=True):
        code = re.sub(r'\b' + re.escape(original) + r'\b', var_map[original], code)
    return code


def obfuscate_rust_vars(filename='src/main.rs'):
    with open(filename, 'r', encoding='utf-8') as f:
        code = f.read()

    let_vars, const_vars = find_variable_names(code)

    let_map = {var: random_let_name() for var in let_vars}
    const_map = {var: random_const_name() for var in const_vars}
    var_map = {**let_map, **const_map}

    obfuscated_code = replace_variables(code, var_map)

    with open(filename + '.bak', 'w', encoding='utf-8') as f:
        f.write(code)

    with open(filename, 'w', encoding='utf-8') as f:
        f.write(obfuscated_code)

    print("Obfuscation complete. Backup saved as 'src/main.rs.bak'.")
    print("Variable mapping:")
    for orig, new in var_map.items():
        print(f"{orig} -> {new}")


if __name__ == '__main__':
    obfuscate_rust_vars()
