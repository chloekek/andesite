unit class Andesite::Minecraft::Server;

has Proc::Async $!proc is required;
has IO::Path $!state-dir is required;

submethod BUILD(::?CLASS:D: IO() :$!state-dir --> Nil)
{
    my $jar := %?RESOURCES<server.jar>;
    my @cmd := «java -Xmx2G -Xms2G -jar “$jar” nogui»;
    $!proc = Proc::Async.new(@cmd, :w);
}

method start(::?CLASS:D: --> Promise:D)
{
    $!proc.start(cwd => $!state-dir);
}

method stop(::?CLASS:D: --> Nil)
{
    self.command: «stop»;
}

method command(::?CLASS:D: *@cmd --> Nil)
{
    $!proc.put: ‘/’ ~ @cmd.join(‘ ’);
}

method ready(::?CLASS:D: --> Promise:D)
{
    $!proc.ready;
}

method output(::?CLASS:D: --> Supply:D)
{
    # TODO: Parse output and emit data structures.
    Supply.merge($!proc.stdout.lines, $!proc.stderr.lines);
}
