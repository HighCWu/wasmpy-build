with open('build/alloc.wat', 'r', encoding='utf-8') as f:
    lines = f.readlines()
    new_lines = []
    for line in lines:
        if 'export "_start"' in line:
            continue
        new_lines.append(line)
        
with open('alloc.wat', 'w+', encoding='utf-8') as f:
    f.writelines(new_lines)
