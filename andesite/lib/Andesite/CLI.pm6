unit module Andesite::CLI;

use Andesite::Minecraft::Config;
use Andesite::Minecraft::DataPack;
use Andesite::Minecraft::Output;
use Andesite::Minecraft::Server;

sub MAIN(IO() :$state-dir --> Nil)
    is export
{
    install-config($state-dir);
    install-data-pack($state-dir);

    my $server := Andesite::Minecraft::Server.new(:$state-dir);

    proto act(Line:D $_ --> Nil)
    {
        say .plain;
        {*}
    }

    multi act(JoinLine:D $_) # TODO: --> Nil
    {
        $server.command: «execute as “{.nickname}” run function ‘andesite:motd’»;
        $server.command: «execute as “{.nickname}” run function ‘andesite:rules’»;
    }

    multi act(OtherLine:D $_ --> Nil)
    {
    }

    react {
        whenever $server.output {
            $_ ==> parse-line() ==> act();
        }

        whenever signal(SIGINT, SIGTERM) {
            $server.stop;
        }

        whenever $server.ready {
            .say;
        }

        whenever $server.start {
            done;
        }
    }
}
