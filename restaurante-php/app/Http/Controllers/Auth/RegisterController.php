<?php

namespace App\Http\Controllers\Auth;

use Illuminate\Support\Str;
use App\User;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Validator;
use Illuminate\Foundation\Auth\RegistersUsers;
use Illuminate\Http\Request;

class RegisterController extends Controller
{
    /*
    |--------------------------------------------------------------------------
    | Register Controller
    |--------------------------------------------------------------------------
    |
    | This controller handles the registration of new users as well as their
    | validation and creation. By default this controller uses a trait to
    | provide this functionality without requiring any additional code.
    |
    */

    use RegistersUsers;

    /**
     * Where to redirect users after registration.
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
        $this->middleware('guest');
    }

    /**
     * Get a validator for an incoming registration request.
     *
     * @param  array  $data
     * @return \Illuminate\Contracts\Validation\Validator
     */
    protected function validator(array $data)
    {
        return Validator::make($data, [
            'email' => 'required|string|email|max:255|unique:users',
            'username' => 'required|string|max:255|unique:users',
            'password' => 'required|string|min:6|confirmed',
        ]);
    }

    /**
     * Create a new user instance after a valid registration.
     *
     * @param  array  $data
     * @return \App\User
     */
    protected function create(array $data)
    {
        return User::create([
            'rol_id' => $data['rol_id'],
            'firstname' => $data['firstname'],
            'surname' => $data['surname'],
            'state' => $data['state'], 
            'username' => $data['username'],
            'email' => $data['email'],
            'password' => bcrypt($data['password']),
        ]);
    }



    public function register(Request $request)
    {
        $this->validator($request->all())->validate();

        $user = User::create([
            'rol_id' => $request['rol_id'],
            'username' => $request['username'],
            'password' => bcrypt($request['password']),
            'firstname' => $request['firstname'],
            'surname' => $request['surname'],
            'email' => $request['email'],
            'state' => $request['state'],
            'api_token' => Str::random(60), 
        ]);
        

        $estadoRegistro=false;
        if($user!=null)
        {
            $estadoRegistro=true;
        }
        return response()->json($estadoRegistro,200);
    }
}
