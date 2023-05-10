<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Models\User;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\File;
use Illuminate\Http\Response;


/**
 * Summary of AuthController
 */
class AuthController extends Controller
{
    // Register user
    public function register(Request $request)
    {
        // Validate fields
        $attrs = $request->validate([
            'name' => 'required|string',
            'email' => 'required|email|unique:users,email',
            'password' => 'required|min:6|confirmed'
        ]);

        // Create user
        $user = User::create([
            'name' => $attrs['name'],
            'email' => $attrs['email'],
            'password' => bcrypt($attrs['password'])
        ]);

        // Return user & token response
        return response([
            'user' => $user,
            'token' => $user->createToken('auth_token')->plainTextToken
        ]);
    }

    // Login user
    public function login(Request $request)
    {
        // Validate fields
        $attrs = $request->validate([
            'email' => 'required|email',
            'password' => 'required|min:6'
        ]);

        // Attempt login
        if (!Auth::attempt($attrs)) {
            return response([
                'message' => 'Invalid credentials.'
            ], 403);
        }

        // Return user & token response
        return response([
            'user' => auth()->user(),
            'token' => $request->user()->createToken('auth_token')->plainTextToken
        ], 200);
    }

    // Logout user
    public function logout(Request $request)
    {
        $request->user()->tokens()->delete();

        return response()->json([
            'message' => 'Logged out successfully!',
            'status_code' => 200
        ], 200);
    }

    // Get user details
    public function user(Request $request)
    {
        return response([
            'user' => $request->user()
        ], 200);
    }

       
    public function getPubliclyStorgeFile($filename)

    {
        $path = storage_path('app/public/posts/'. $filename);
        $path = storage_path('app/public/profiles/'. $filename);

    
        if (!File::exists($path)) {
            abort(404);
        }
    
        $file = File::get($path);
        $type = File::mimeType($path);
    
        $response = Response::make($file, 200);
    
        $response->header("Content-Type", $type);
    
        return $response;
    
    }	
}
