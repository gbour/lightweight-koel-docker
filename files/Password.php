<?php

namespace App\Console\Commands;

#use DB;
#use Exception;
use App\Models\User;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Hash;


class Password extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'koel:pwd';


    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Update admin password';

    /**
     * Execute the console command.
     *
     * @return mixed
     */
    public function handle()
    {
        $user = User::find(1);
        $pwd =  Hash::make(getenv('ADMIN_PASSWORD'));

        //$this->info("user= $user, pwd=" . $pwd);
        $user->update(['password' => $pwd]);
        $this->info('password updated.');
    }
}
