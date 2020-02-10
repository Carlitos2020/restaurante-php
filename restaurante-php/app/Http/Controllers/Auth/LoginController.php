<?php

namespace App\Http\Controllers\Auth;

use Illuminate\Support\Str;
use App\Http\Controllers\Controller;
use Illuminate\Foundation\Auth\AuthenticatesUsers;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\User;

class LoginController extends Controller
{
    /*
    |--------------------------------------------------------------------------
    | Login Controller
    |--------------------------------------------------------------------------
    |
    | This controller handles authenticating users for the application and
    | redirecting them to your home screen. The controller uses a trait
    | to conveniently provide its functionality to your applications.
    |
    */

    use AuthenticatesUsers;

    /**
     * Where to redirect users after login.
     *
     * @var string
     */
    protected $redirectTo = '/home';

    /**
     * Create a new controller instance.
     *
     * @return void
     */
    public function __construct()
    {
        $this->middleware('guest')->except('logout','obtenerUsuario');
    }


    public function username()
    {
        return 'username';
    }



    public function login(Request $request)
    {
        $this->validateLogin($request);

        if ($this->attemptLogin($request)) {
            $user = Auth::user();
            $token = Str::random(60);
            $user->forceFill([
                'api_token' => hash('sha256', $token),
            ])->save();

            $success['ok'] = true;
            $success['result'] = $user;
            return response()->json($success, 200);
        }

        $rtn=[
            "ok"=>false,
            "msg"=>"Usuario no registrado"
        ];
        return response()->json($rtn,200);
    }

    public function logout()
    {
        $user = Auth::user();
        $token = Str::random(60);
        $user->forceFill([
            'api_token' => hash('sha256', $token),
        ])->save();

        return response()->json([
            "status"=>true
        ], 200);        
    }


    public function obtenerUsuario()
    {
        $user = Auth::user();
        return response()->json($user, 200);     
    }

}
