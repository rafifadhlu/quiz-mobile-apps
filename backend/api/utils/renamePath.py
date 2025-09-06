import os
import datetime
import uuid

def renaming_question_file(instance,filename):
    base,ext = os.path.splitext(filename)
    uploadedTime = datetime.now().strftime('%Y_%m_%d')
    quiz_id = instance.quiz
    questions = instance.id
    allowed_img = ['.jpg', '.jpeg', '.png']
    allowed_audio = ['.mp3', '.wav'] 

    if ext in allowed_img:
        full_format_name = f'image/{quiz_id}_{questions}_{uploadedTime}{ext}'
    
    if ext in allowed_audio:
        full_format_name = f'audio/{quiz_id}_{questions}_{uploadedTime}{ext}'

    return full_format_name