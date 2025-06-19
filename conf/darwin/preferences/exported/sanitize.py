#!/usr/bin/env python3

# Removes keys that are not needed in the plist files
# Like NSxx

import plistlib
from pathlib import Path

def remove_keys_with_prefix(plist_data, prefix):
    """Remove keys from plist data that start with the specified prefix."""
    keys_to_remove = [key for key in plist_data.keys() if key.startswith(prefix)]
    for key in keys_to_remove:
        del plist_data[key]
    return plist_data

def sanitize_plist(plist_data):
    plist_data = remove_keys_with_prefix(plist_data, 'NS')
    plist_data = remove_keys_with_prefix(plist_data, 'SU')
    plist_data = remove_keys_with_prefix(plist_data, 'last')
    plist_data = remove_keys_with_prefix(plist_data, 'recent')
    
    # CotEditor find history
    plist_data = remove_keys_with_prefix(plist_data, 'findHistory')
    
    plist_data = remove_keys_with_prefix(plist_data, 'Release Group')
    plist_data = remove_keys_with_prefix(plist_data, 'Paddle')
    
    return plist_data

def process_plists():
    # Get the current working directory
    cwd = Path.cwd()
    
    # Find all plist files
    plist_files = list(cwd.glob('*.plist'))
    
    if not plist_files:
        print("No plist files found in the current directory.")
        return
    
    for plist_path in plist_files:
        try:
            with open(plist_path, 'rb') as fp:
                plist_data = sanitize_plist(plistlib.load(fp))
                
                # Write back the modified plist
                with open(plist_path, 'wb') as fp_out:
                    plistlib.dump(plist_data, fp_out)
                
        except Exception as e:
            print(f"Error processing {plist_path.name}: {e}")

if __name__ == "__main__":
    process_plists()
