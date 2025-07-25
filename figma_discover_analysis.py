import json

with open('figma_file.json', 'r') as f:
    data = json.load(f)

def find_frame_by_name(node, name):
    if node.get('name', '').lower() == name.lower() and node.get('type') in ['FRAME', 'COMPONENT']:
        return node
    
    if 'children' in node:
        for child in node['children']:
            result = find_frame_by_name(child, name)
            if result:
                return result
    return None

def extract_layout_info(node):
    info = {
        'name': node.get('name', ''),
        'type': node.get('type', ''),
        'id': node.get('id', ''),
    }
    
    # Position and size
    if 'absoluteBoundingBox' in node:
        bounds = node['absoluteBoundingBox']
        info['x'] = bounds.get('x', 0)
        info['y'] = bounds.get('y', 0) 
        info['width'] = bounds.get('width', 0)
        info['height'] = bounds.get('height', 0)
    
    # Layout properties
    info['layoutMode'] = node.get('layoutMode', None)
    info['primaryAxisSizingMode'] = node.get('primaryAxisSizingMode', None)
    info['counterAxisSizingMode'] = node.get('counterAxisSizingMode', None)
    info['primaryAxisAlignItems'] = node.get('primaryAxisAlignItems', None)
    info['counterAxisAlignItems'] = node.get('counterAxisAlignItems', None)
    info['layoutAlign'] = node.get('layoutAlign', None)
    info['layoutGrow'] = node.get('layoutGrow', None)
    
    # Padding and spacing
    info['paddingLeft'] = node.get('paddingLeft', 0)
    info['paddingRight'] = node.get('paddingRight', 0)
    info['paddingTop'] = node.get('paddingTop', 0)
    info['paddingBottom'] = node.get('paddingBottom', 0)
    info['itemSpacing'] = node.get('itemSpacing', 0)
    
    # Style properties
    if 'fills' in node and node['fills']:
        fill = node['fills'][0]
        if fill.get('type') == 'SOLID' and 'color' in fill:
            color = fill['color']
            info['backgroundColor'] = f"rgba({int(color['r']*255)}, {int(color['g']*255)}, {int(color['b']*255)}, {color['a']})"
    
    if 'cornerRadius' in node:
        info['cornerRadius'] = node.get('cornerRadius', 0)
    
    # Text properties
    if node.get('type') == 'TEXT':
        info['characters'] = node.get('characters', '')
        if 'style' in node:
            style = node['style']
            info['fontSize'] = style.get('fontSize', 14)
            info['fontFamily'] = style.get('fontFamily', 'Pretendard')
            info['fontWeight'] = style.get('fontWeight', 400)
            info['textAlignHorizontal'] = style.get('textAlignHorizontal', 'LEFT')
            
            # Get text color
            if 'fills' in node and node['fills']:
                fill = node['fills'][0]
                if fill.get('type') == 'SOLID' and 'color' in fill:
                    color = fill['color']
                    info['textColor'] = f"rgba({int(color['r']*255)}, {int(color['g']*255)}, {int(color['b']*255)}, {color['a']})"
    
    # Process children
    if 'children' in node:
        info['children'] = [extract_layout_info(child) for child in node['children']]
    
    return info

# Find the Discover frame
discover_frame = find_frame_by_name(data['document'], 'discover')

if discover_frame:
    layout_info = extract_layout_info(discover_frame)
    
    # Save the extracted info
    with open('discover_layout.json', 'w') as f:
        json.dump(layout_info, f, indent=2)
    
    print("Layout information extracted successfully!")
    
    # Print a summary
    def print_structure(node, indent=0):
        print('  ' * indent + f"{node['name']} ({node['type']})")
        if node.get('layoutMode'):
            print('  ' * indent + f"  Layout: {node['layoutMode']}")
            print('  ' * indent + f"  Primary: {node.get('primaryAxisSizingMode', 'N/A')}")
            print('  ' * indent + f"  Counter: {node.get('counterAxisSizingMode', 'N/A')}")
        if 'children' in node:
            for child in node['children']:
                print_structure(child, indent + 1)
    
    print_structure(layout_info)
else:
    print("Discover frame not found")