# Note: This script was generated using AI. The purpose of this script was to place iceedge.png
# over specific sections of existing tilesets for the Fire/Ice themed dungeon.

import os
import re
from PIL import Image

def process_images(input_dir, output_dir, template_path):
    """
    Process PNG images by creating composite images with template overlay.
    Template pixels are only used where they are non-transparent.
    
    Args:
        input_dir: Directory containing source PNG images (432x192)
        output_dir: Directory where output images will be saved
        template_path: Path to the template.png file
    """
    # Create output directory if it doesn't exist
    os.makedirs(output_dir, exist_ok=True)
    
    # Load template image
    try:
        template = Image.open(template_path)
        # Convert to RGBA to ensure we can check alpha channel
        template = template.convert('RGBA')
        print(f"Loaded template: {template_path}")
    except Exception as e:
        print(f"Error loading template: {e}")
        return
    
    # Get all PNG files matching the pattern tileset_0_frame0_X.3.png
    png_files = []
    pattern = re.compile(r'tileset_0_frame0_(\d+)\.3\.png')
    
    for filename in os.listdir(input_dir):
        match = pattern.match(filename)
        if match:
            x_value = int(match.group(1))
            png_files.append((x_value, filename))
    
    # Sort by X value (smallest to greatest)
    png_files.sort(key=lambda item: item[0])
    
    if not png_files:
        print(f"No PNG files matching pattern 'tileset_0_frame0_X.3.png' found in {input_dir}")
        return
    
    print(f"Found {len(png_files)} PNG files to process")
    
    # Process each image
    for idx, (x_value, filename) in enumerate(png_files):
        input_path = os.path.join(input_dir, filename)
        output_filename = f"tileset_0_frame0_{idx}.3.png"
        output_path = os.path.join(output_dir, output_filename)
        
        try:
            # Load source image
            source_img = Image.open(input_path).convert('RGBA')
            
            # Verify dimensions
            if source_img.size != (432, 192):
                print(f"Warning: {filename} has size {source_img.size}, expected (432, 192)")
            
            # Create blank 432x192 image
            output_img = Image.new('RGBA', (432, 192), (0, 0, 0, 0))
            
            # Copy pixels from source image at x=144, y=0, width=144, height=192
            source_crop = source_img.crop((144, 0, 288, 192))
            output_img.paste(source_crop, (144, 0))
            
            # Copy pixels from template at x=144, y=0, width=144, height=192
            # Only paste where template has non-transparent pixels
            template_crop = template.crop((144, 0, 288, 192))
            
            # Use template's alpha channel as mask so transparent areas show source image
            output_img.paste(template_crop, (144, 0), template_crop)
            
            # Save output image
            output_img.save(output_path)
            print(f"Created: {output_filename} (from {filename}, X={x_value})")
            
        except Exception as e:
            print(f"Error processing {filename}: {e}")
    
    print(f"\nProcessing complete! Output saved to: {output_dir}")

if __name__ == "__main__":
    # Specify your directories and template path here
    input_directory = "input"  # Change this to your input directory
    output_directory = "output"  # Change this to your output directory
    template_filepath = "iceedge.png"  # Change this to your template file path
    
    process_images(input_directory, output_directory, template_filepath)