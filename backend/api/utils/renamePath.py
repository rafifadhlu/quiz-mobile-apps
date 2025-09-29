import os
import datetime
import uuid

def renaming_question_file(instance, filename):
    base, ext = os.path.splitext(filename)
    uploaded_time = datetime.datetime.now().strftime("%Y%m%d%H%M%S")
    quiz_id = instance.quiz.id  # Get the actual ID
    question_id = instance.id if instance.id else 'new'  # Handle new instances
    
    allowed_img = ['.jpg', '.jpeg', '.png']
    allowed_audio = ['.mp3', '.wav'] 
    
    # Convert extension to lowercase for comparison
    ext_lower = ext.lower()
    
    if ext_lower in allowed_img:
        full_format_name = f'image/{quiz_id}_{question_id}_{uploaded_time}{ext}'
    elif ext_lower in allowed_audio:  # Use elif, not separate if
        full_format_name = f'audio/{quiz_id}_{question_id}_{uploaded_time}{ext}'
    else:
        # Handle unsupported file types
        raise ValueError(f"Unsupported file type: {ext}")
    
    return full_format_name