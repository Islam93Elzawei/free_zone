<?php

namespace App\Http\Controllers;
use Illuminate\Foundation\Bus\DispatchesJobs;
use Illuminate\Foundation\Auth\Access\AuthorizesRequests;
use Illuminate\Foundation\Validation\ValidatesRequests;
use Illuminate\Routing\Controller as BaseController;
use Illuminate\Support\Facades\URL;
use Illuminate\Support\Facades\Storage;
use Illuminate\Http\Request;


class Controller extends BaseController
{
    use AuthorizesRequests,DispatchesJobs, ValidatesRequests;
    
    public function saveImage($image, $path = 'public')
    {
        if(!$image)
        {
            return null;
        }

        $filename = time().'.png';
        // save image
        Storage::disk('public')->put($path .'/'. $filename, base64_decode($image));
                Storage::disk('public')->put($path .'/'. $filename, base64_decode($image));

        

    
        return URL::to('/').'/Storage/'.$path.'/'.$filename;
    }
    public function uploadImage(Request $request) {
        if ($request->hasFile('image')) {
          $file = $request->file('image');
          $filename = $file->getClientOriginalName();
          $path = $request->file('image')->storeAs('public/images', $filename);
          return response()->json(['message' => 'Image uploaded successfully']);
        } else {
          return response()->json(['message' => 'No file uploaded']);
        }
      }
      public function saveUserProfileImage($image, $userId)
{
    if (!$image) {
        return null;
    }

    $filename = $userId . '.png';
    // save image
    Storage::disk('public')->put('user-profiles/' . $filename, base64_decode($image));
    return URL::to('/').'/Storage/user-profiles/'.$filename;
}
      
}
