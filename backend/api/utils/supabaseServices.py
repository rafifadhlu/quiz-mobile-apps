import os
from supabase import create_client

# def get_signed_url(file_path):
#     # First debug the path
    
#     supabase = create_client(os.getenv("SUPABASE_URL"), os.getenv("SUPABASE_ROLE_KEY"))
#     media_bucket = os.getenv("SUPABASE_MEDIA_BUCKET")
    
#             try:
#                 response = supabase.storage.from_(media_bucket).create_signed_url(path_variant, 60)
#                 return response.get('signedUrl') or response.get('signedURL')
#             except Exception as e:
#                 return None
    

def connect_supabase():
    supabase = create_client(os.getenv("SUPABASE_URL"), os.getenv("SUPABASE_ROLE_KEY"))
    return supabase 

def get_signed_urls(file_names):
    supabase = connect_supabase()
    media_bucket = os.getenv("SUPABASE_MEDIA_BUCKET")


    try:
        signed_map = {}
        for file_name in file_names:
            url = supabase.storage.from_(media_bucket).create_signed_url(file_name, 60)  # 1 min expiry
            signed_map[file_name] = url['signedUrl']  # Supabase returns dict with 'signedUrl'
        return signed_map
    except Exception as e:
        print("Error getting signed url:",e)
        return None

def delete_file(file_path):
    supabase = connect_supabase()
    media_bucket = os.getenv("SUPABASE_MEDIA_BUCKET")

    try:
        response = supabase.storage.from_(media_bucket).remove([file_path])
        return response
    except Exception as e:
        return str(e)