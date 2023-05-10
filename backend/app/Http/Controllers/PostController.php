<?php

namespace App\Http\Controllers;

use App\Models\Post;
use Illuminate\Http\Request;

class PostController extends Controller
{
    //get all posts


    public function index() {
        return response([
            'posts' => Post::orderBy('created_at', 'desc')
                ->with('user:id,name,image')
                ->withCount('comments', 'likes')
                ->with(['likes' => function ($like) {
                    $like->where('user_id', auth()->user()->id)
                        ->select('id', 'user_id', 'post_id');
                }])
                ->get()
        ], 200);
    }
    
    
    //show a post
   //show a post
public function show($id){
    $post = Post::where('id', $id)->withCount('comments', 'likes')->first();

    // Check if post has an image
    $image = null;
    if ($post->image) {
        $image = url('storage/' . $post->image);
    }

    return response([
        'post' => [
            'id' => $post->id,
            'body' => $post->body,
            'image' => $image, // Include image URL in the response
            'created_at' => $post->created_at,
            'updated_at' => $post->updated_at,
            'user' => [
                'id' => $post->user->id,
                'name' => $post->user->name,
                'image' => $post->user->image,
            ],
            'comments_count' => $post->comments_count,
            'likes_count' => $post->likes_count,
        ],
    ], 200);
}

    
    //create a post
    public function store(Request $request){
        $attrs = $request->validate([
            'body' => 'required|string',    
        ]);
        $image = $this->saveImage($request->    image,'posts');
        $post = Post::create([
            'body' => $attrs['body'],
            'user_id' => auth()->user()->id,
            'image'=> $image 
        ]);
        return response([
            'message' => 'Post created.',
            'post' => $post
        ], 200);
    }
    
    //update a post
    public function update(Request $request, $id){
        $post = Post::find($id);
        if (!$post) {
            return response([
                'message' => 'Post not found.'
            ], 404);
        }
        if ($post->user_id != auth()->user()->id) {
            return response([
                'message' => 'Permission denied.'
            ], 403);
        }
        $attrs = $request->validate([
            'body' => 'required|string',
            'image' => 'nullable|image'
        ]);
        if ($request->hasFile('image')) {
            $image = $this->saveImage($request->image, 'posts');
            $post->image = $image;
        }
        $post->body = $attrs['body'];
        $post->save();
        return response([
            'message' => 'Post updated.',
            'post' => $post
        ], 200);
    }
    
    //delete a post
    public function destroy($id){
        $post = Post::find($id);
        if (!$post) {
            return response([
                'message' => 'Post not found.'
            ], 404);
        }
        if ($post->user_id != auth()->user()->id) {
            return response([
                'message' => 'Permission denied.'
            ], 403);
        }
        $post->comments()->delete(); // Delete comments first
        $post->likes()->delete(); // Delete likes next
        $post->delete(); // Delete post last
        return response([
            'message' => 'Post deleted.'
        ], 200);
    }
}
