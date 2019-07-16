use Andesite::Minecraft::Output;
use Test;

plan 4;

subtest ｢empty line｣ => {
    my $line := ｢｣;
    cmp-ok parse-line($line), ‘eqv’, OtherLine.new(plain => $line);
}

subtest ｢prefix only｣ => {
    my $line := ｢[20:35:03] [Server thread/INFO]: ｣;
    cmp-ok parse-line($line), ‘eqv’, OtherLine.new(plain => $line);
}

subtest ｢join line｣ => {
    my $line := ｢[20:35:03] [Server thread/INFO]: CakeOfPork joined the game｣;
    cmp-ok parse-line($line), ‘eqv’,
           JoinLine.new(plain => $line, nickname => ‘CakeOfPork’);
}

subtest ｢other line｣ => {
    my $line := ｢[20:35:03] [Server thread/INFO]: foo bar｣;
    cmp-ok parse-line($line), ‘eqv’, OtherLine.new(plain => $line);
}
