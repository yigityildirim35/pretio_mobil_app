import sys
from PIL import Image

def process_logo(input_path, icon_output, splash_output):
    try:
        # Load original logo
        img = Image.open(input_path).convert("RGBA")
        
        # Get bounding box of the non-transparent content
        bbox = img.getbbox()
        if not bbox:
            print("Image is completely transparent!")
            return
            
        # Crop to the actual logo content
        cropped_img = img.crop(bbox)
        logo_width, logo_height = cropped_img.size
        
        # Canvas Size
        CANVAS_SIZE = 1024
        
        # --- 1. APP ICON: 68% of canvas height (696px) ---
        icon_target_height = int(CANVAS_SIZE * 0.68)
        # Calculate width proportionally
        aspect_ratio = logo_width / logo_height
        icon_target_width = int(icon_target_height * aspect_ratio)
        
        # Resize logo for icon
        icon_logo_resized = cropped_img.resize((icon_target_width, icon_target_height), Image.Resampling.LANCZOS)
        
        # Create transparent canvas for icon
        icon_canvas = Image.new("RGBA", (CANVAS_SIZE, CANVAS_SIZE), (255, 255, 255, 0))
        
        # Center coordinates
        icon_x = (CANVAS_SIZE - icon_target_width) // 2
        icon_y = (CANVAS_SIZE - icon_target_height) // 2
        
        # Paste resized logo onto transparent canvas
        icon_canvas.paste(icon_logo_resized, (icon_x, icon_y), icon_logo_resized)
        icon_canvas.save(icon_output, "PNG")
        print(f"App Icon saved to {icon_output}")
        
        # --- 2. SPLASH SCREEN: 38% of canvas height (389px) ---
        splash_target_height = int(CANVAS_SIZE * 0.38)
        splash_target_width = int(splash_target_height * aspect_ratio)
        
        # Resize logo for splash screen
        splash_logo_resized = cropped_img.resize((splash_target_width, splash_target_height), Image.Resampling.LANCZOS)
        
        # Create white background canvas for splash screen
        splash_canvas = Image.new("RGBA", (CANVAS_SIZE, CANVAS_SIZE), (255, 255, 255, 255))
        
        # Center coordinates
        splash_x = (CANVAS_SIZE - splash_target_width) // 2
        splash_y = (CANVAS_SIZE - splash_target_height) // 2
        
        # Paste resized logo onto white canvas using itself as a mask
        splash_canvas.paste(splash_logo_resized, (splash_x, splash_y), splash_logo_resized)
        
        # Save as PNG without alpha for splash screen background
        splash_canvas.convert("RGB").save(splash_output, "PNG")
        print(f"Splash Screen saved to {splash_output}")

    except Exception as e:
        print(f"Error processing image: {e}")

if __name__ == "__main__":
    INPUT_FILE = "assets/images/ogol.png"
    ICON_OUT = "assets/images/icon_1024.png"
    SPLASH_OUT = "assets/images/splash_logo.png"
    
    process_logo(INPUT_FILE, ICON_OUT, SPLASH_OUT)
