unit module Andesite::Minecraft::DataPack;

sub install-data-pack(IO() $state-dir --> Nil)
    is export
{
    my $pack := $state-dir.add(‘world/datapacks/andesite’);
    my $functions := $pack.add(‘data/andesite/functions’);
    $functions.mkdir;

    # FIXME: Generate a .zip file for the datapack so that replacing it is
    # FIXME: easier. No need to work with nested directory structures.

    my $meta := %?RESOURCES<pack.mcmeta>.slurp;
    $pack.add(‘pack.mcmeta’).spurt($meta);

    my $rules := %?RESOURCES<rules.mcfunction>.slurp;
    $functions.add(‘rules.mcfunction’).spurt($rules);

    my $motd := %?RESOURCES<motd.mcfunction>.slurp;
    $functions.add(‘motd.mcfunction’).spurt($motd);
}
