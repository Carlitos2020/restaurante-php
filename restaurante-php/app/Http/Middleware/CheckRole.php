<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Support\Facades\Auth;

class CheckRole
{
    /**
     * Handle an incoming request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure  $next
     * @return mixed
     */
    public function handle($request, Closure $next,...$roles)
    {
        $flag=false;
        $user = Auth::user();
        $user_rol_id=$user->rol_id;
        foreach ($roles as $role) {
            if($user_rol_id==$role)
            {
                $flag=true;
            }
        }

        if(!$flag)
        {
            return redirect()->route('deniedAccess');
        }

        return $next($request);
    }
}
