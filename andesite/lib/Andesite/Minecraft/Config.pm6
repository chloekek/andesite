=begin pod

=head1 NAME

Andesite::Minecraft::Config - Install Minecraft configuration

=head1 SYNOPSIS

    use Andesite::Minecraft::Config;

    my $state-dir := ‘/var/lib/minecraft’.IO;
    install-config $state-dir;

=head1 DESCRIPTION

This module provides routines for installing the Minecraft server
configuration. This includes primarily the server.properties and eula.txt
files. They are installed into the state directory, which is the working
directory of the Minecraft server. The configuration should be installed
prior to starting the Minecraft server.

=end pod

unit module Andesite::Minecraft::Config;

sub install-config(IO() $state-dir --> Nil)
    is export
{
    install-server-properties($state-dir);
    install-eula($state-dir);
    install-server-icon($state-dir);
}

sub install-server-properties(IO() $state-dir --> Nil)
    is export
{
    my $file := $state-dir.add(‘server.properties’);
    my $resource-pack-sha1 := %?RESOURCES<andesite-resources.zip.sha1>.slurp;
    $file.spurt: qq:to/EOF/;
        # Informational
        motd=A Minecraft Server

        # Networking
        enable-query=false
        enable-rcon=false
        online-mode=true
        prevent-proxy-connections=false
        query.port=25565
        rcon.password=
        server-ip=
        server-port=25565
        snooper-enabled=true
        use-native-transport=true

        # Game rules
        allow-flight=false
        allow-nether=true
        difficulty=normal
        enable-command-block=false
        force-gamemode=false
        gamemode=survival
        hardcore=false
        pvp=false
        spawn-animals=true
        spawn-monsters=true
        spawn-npcs=true

        # World generation
        generate-structures=true
        generator-settings=
        level-name=world
        level-seed=
        level-type=default

        # Administration
        broadcast-console-to-ops=true
        broadcast-rcon-to-ops=true
        enforce-whitelist=false
        function-permission-level=2
        op-permission-level=4
        rcon.port=25575
        white-list=true

        # Limits
        max-build-height=256
        max-players=20
        max-tick-time=60000
        max-world-size=29999984
        network-compression-threshold=256
        player-idle-timeout=0
        view-distance=10

        # Resource pack
        resource-pack-sha1=$resource-pack-sha1
        resource-pack=http\://localhost\:8000/andesite-resources.zip
        EOF
}

sub install-eula(IO() $state-dir --> Nil)
    is export
{
    my $file := $state-dir.add(‘eula.txt’);
    $file.spurt: “eula=true\n”;
}

sub install-server-icon(IO() $state-dir --> Nil)
    is export
{
    my $source := %?RESOURCES<server-icon.png>;
    my $target := $state-dir.add(‘server-icon.png’);
    $source.copy: $target;
    $target.chmod: 0o644;
}
