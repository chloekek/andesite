unit module Andesite::Minecraft::Output;

role Line
    is export
{
    has Str $.plain is required;
}

class JoinLine
    is export
    does Line
{
    has Str $.nickname is required;
}

class OtherLine
    is export
    does Line
{
}

my grammar Grammar
{
    token TOP
    {
        [<!before ｢]: ｣> .]* ｢]: ｣
        <line>
    }

    proto token line {*}

    token line:sym<join>
    {
        <nickname> ｢ joined the game｣
    }

    token nickname
    {
        <[A..Z a..z 0..9 _]>+
    }
}

my class Actions
{
    method TOP($/)
    {
        make $<line>.made;
    }

    method line:sym<join>($/)
    {
        make { JoinLine.new(:$^plain, nickname => ~$<nickname>) };
    }
}

our sub parse-line(Str:D $line --> Line:D)
    is export
{
    sub other { OtherLine.new(:$^plain) }
    my &finalize := Grammar.parse($line, actions => Actions).made // &other;
    finalize($line);
}
