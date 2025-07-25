import json

with open('discover_layout.json', 'r') as f:
    data = json.load(f)

def convert_figma_to_flutter(node, indent=0):
    code = []
    ind = '  ' * indent
    
    # Handle different node types
    if node['type'] == 'FRAME':
        # Check layout mode
        if node.get('layoutMode') == 'VERTICAL':
            code.append(f"{ind}Column(")
            if node.get('itemSpacing', 0) > 0:
                code.append(f"{ind}  spacing: {node['itemSpacing']},")
            if node.get('primaryAxisAlignItems'):
                align_map = {
                    'MIN': 'MainAxisAlignment.start',
                    'CENTER': 'MainAxisAlignment.center', 
                    'MAX': 'MainAxisAlignment.end',
                    'SPACE_BETWEEN': 'MainAxisAlignment.spaceBetween'
                }
                code.append(f"{ind}  mainAxisAlignment: {align_map.get(node['primaryAxisAlignItems'], 'MainAxisAlignment.start')},")
            if node.get('counterAxisAlignItems'):
                cross_map = {
                    'MIN': 'CrossAxisAlignment.start',
                    'CENTER': 'CrossAxisAlignment.center',
                    'MAX': 'CrossAxisAlignment.end',
                    'STRETCH': 'CrossAxisAlignment.stretch'
                }
                code.append(f"{ind}  crossAxisAlignment: {cross_map.get(node['counterAxisAlignItems'], 'CrossAxisAlignment.start')},")
            code.append(f"{ind}  children: [")
            
        elif node.get('layoutMode') == 'HORIZONTAL':
            code.append(f"{ind}Row(")
            if node.get('itemSpacing', 0) > 0:
                code.append(f"{ind}  spacing: {node['itemSpacing']},")
            if node.get('primaryAxisAlignItems'):
                align_map = {
                    'MIN': 'MainAxisAlignment.start',
                    'CENTER': 'MainAxisAlignment.center',
                    'MAX': 'MainAxisAlignment.end',
                    'SPACE_BETWEEN': 'MainAxisAlignment.spaceBetween'
                }
                code.append(f"{ind}  mainAxisAlignment: {align_map.get(node['primaryAxisAlignItems'], 'MainAxisAlignment.start')},")
            code.append(f"{ind}  children: [")
        else:
            # No auto layout
            code.append(f"{ind}Container(")
            if 'width' in node:
                code.append(f"{ind}  width: {node['width']},")
            if 'height' in node:
                code.append(f"{ind}  height: {node['height']},")
            
            # Add padding
            padding_values = []
            if any([node.get('paddingLeft', 0), node.get('paddingRight', 0), node.get('paddingTop', 0), node.get('paddingBottom', 0)]):
                code.append(f"{ind}  padding: EdgeInsets.only(")
                if node.get('paddingLeft', 0) > 0:
                    code.append(f"{ind}    left: {node['paddingLeft']},")
                if node.get('paddingRight', 0) > 0:
                    code.append(f"{ind}    right: {node['paddingRight']},")
                if node.get('paddingTop', 0) > 0:
                    code.append(f"{ind}    top: {node['paddingTop']},")
                if node.get('paddingBottom', 0) > 0:
                    code.append(f"{ind}    bottom: {node['paddingBottom']},")
                code.append(f"{ind}  ),")
            
            if node.get('cornerRadius', 0) > 0:
                code.append(f"{ind}  decoration: BoxDecoration(")
                code.append(f"{ind}    borderRadius: BorderRadius.circular({node['cornerRadius']}),")
                if 'backgroundColor' in node:
                    code.append(f"{ind}    color: Color({hex_to_flutter(node['backgroundColor'])}),")
                code.append(f"{ind}  ),")
            elif 'backgroundColor' in node:
                code.append(f"{ind}  color: Color({hex_to_flutter(node['backgroundColor'])}),")
                
            if 'children' in node and node['children']:
                code.append(f"{ind}  child: ")
                
    elif node['type'] == 'TEXT':
        code.append(f"{ind}Text(")
        code.append(f'{ind}  "{node.get("characters", "")}",')
        code.append(f"{ind}  style: TextStyle(")
        if 'textColor' in node:
            code.append(f"{ind}    color: Color({hex_to_flutter(node['textColor'])}),")
        if 'fontSize' in node:
            code.append(f"{ind}    fontSize: {node['fontSize']},")
        code.append(f"{ind}    fontFamily: 'Pretendard',")
        if 'fontWeight' in node:
            code.append(f"{ind}    fontWeight: FontWeight.w{node['fontWeight']},")
        code.append(f"{ind}  ),")
        code.append(f"{ind})")
        return code
    
    # Process children
    if 'children' in node:
        for i, child in enumerate(node['children']):
            child_code = convert_figma_to_flutter(child, indent + 2)
            code.extend(child_code)
            if i < len(node['children']) - 1:
                code[-1] += ','
    
    # Close widget
    if node['type'] == 'FRAME':
        if node.get('layoutMode') in ['VERTICAL', 'HORIZONTAL']:
            code.append(f"{ind}  ],")
            code.append(f"{ind})")
        else:
            if 'children' in node and node['children']:
                code.append(f"{ind})")
            else:
                code.append(f"{ind})")
    
    return code

def hex_to_flutter(rgba_string):
    # Convert rgba(255, 255, 255, 1.0) to 0xFFFFFFFF
    import re
    match = re.match(r'rgba\((\d+),\s*(\d+),\s*(\d+),\s*([\d.]+)\)', rgba_string)
    if match:
        r, g, b, a = match.groups()
        alpha = int(float(a) * 255)
        return f"0x{alpha:02X}{int(r):02X}{int(g):02X}{int(b):02X}"
    return "0xFFFFFFFF"

# Generate code for key components
def generate_screen_code():
    print("// Auto-generated from Figma")
    print("class FigmaAccurateDiscoverScreen extends StatelessWidget {")
    print("  @override")
    print("  Widget build(BuildContext context) {")
    print("    return Scaffold(")
    print("      body: Container(")
    print(f"        width: {data['width']},")
    print(f"        height: {data['height']},")
    print("        color: Colors.white,")
    print("        child: Column(")
    
    # Process main structure
    for child in data['children']:
        if child['name'] == 'Main Container':
            print(f"          // {child['name']}")
            print(f"          Container(")
            print(f"            width: {child['width']},")
            print(f"            height: {child['height']},")
            # ... continue processing
            
    print("        ),")
    print("      ),")
    print("    );")
    print("  }")
    print("}")

# Extract exact component measurements
def extract_measurements():
    components = {}
    
    def find_component(node, path=""):
        current_path = f"{path}/{node['name']}" if path else node['name']
        
        comp_info = {
            'type': node['type'],
            'width': node.get('width', 0),
            'height': node.get('height', 0),
            'x': node.get('x', 0),
            'y': node.get('y', 0),
            'layoutMode': node.get('layoutMode'),
            'itemSpacing': node.get('itemSpacing', 0),
            'paddingLeft': node.get('paddingLeft', 0),
            'paddingRight': node.get('paddingRight', 0),
            'paddingTop': node.get('paddingTop', 0),
            'paddingBottom': node.get('paddingBottom', 0),
        }
        
        if node['type'] == 'TEXT':
            comp_info['text'] = node.get('characters', '')
            comp_info['fontSize'] = node.get('fontSize', 14)
            comp_info['fontWeight'] = node.get('fontWeight', 400)
            comp_info['color'] = node.get('textColor', '')
            
        components[current_path] = comp_info
        
        if 'children' in node:
            for child in node['children']:
                find_component(child, current_path)
    
    find_component(data)
    
    # Print key measurements
    print("\n=== KEY MEASUREMENTS ===")
    for path, info in components.items():
        if 'Profile Card' in path and info['type'] == 'FRAME':
            print(f"\n{path}:")
            print(f"  Size: {info['width']} x {info['height']}")
            print(f"  Padding: L{info['paddingLeft']} T{info['paddingTop']} R{info['paddingRight']} B{info['paddingBottom']}")
            if info['layoutMode']:
                print(f"  Layout: {info['layoutMode']} spacing: {info['itemSpacing']}")

extract_measurements()