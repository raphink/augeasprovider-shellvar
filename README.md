# augeasprovider-shellvar: an Augeas-based shellvar type and provider for Puppet

This module provides a shellvar type and provider for Puppet
using the Augeas configuration library and the augeasprovider-core module.

The advantage of using Augeas over the default Puppet `parsedfile`
implementations is that Augeas will go to great lengths to preserve file
formatting and comments, while also failing safely when needed.

This provider will hide *all* of the Augeas commands etc., you don't need to
know anything about Augeas to make use of it.

If you want to make changes to config files in your own way, you should use
the `augeas` type directly.  For more information about Augeas, see the
[web site](http://augeas.net) or the
[Puppet/Augeas](http://projects.puppetlabs.com/projects/puppet/wiki/Puppet_Augeas)
wiki page.


## Requirements

Ensure both Augeas and ruby-augeas 0.3.0+ bindings are installed and working as
normal.

See [Puppet/Augeas pre-requisites](http://projects.puppetlabs.com/projects/puppet/wiki/Puppet_Augeas#Pre-requisites).

## Installing

On Puppet 2.7.14+, the module can be installed easily ([documentation](http://docs.puppetlabs.com/puppet/2.7/reference/modules_installing.html)):

    puppet module install domcleal/augeasprovider-shellvar

You may see an error similar to this on Puppet 2.x ([#13858](http://projects.puppetlabs.com/issues/13858)):

    Error 400 on SERVER: Puppet::Parser::AST::Resource failed with error ArgumentError: Invalid resource type `kernel_parameter` at ...

Ensure the module is present in your puppetmaster's own environment (it doesn't
have to use it) and that the master has pluginsync enabled.  Run the agent on
the puppetmaster to cause the custom types to be synced to its local libdir
(`puppet master --configprint libdir`) and then restart the puppetmaster so it
loads them.


## Compatibility

### Puppet versions

Puppet Versions | 2.6 -> 3.4 | >= 3.4   |
:---------------|:----------:|:-------:|
shared handler  | no         | **yes** |

### Augeas versions

Augeas Versions           | 0.10.0  | 1.0.0   | 1.1.0   | 1.2.0   |
:-------------------------|:-------:|:-------:|:-------:|:-------:|
**FEATURES**              |
case-insensitive keys     | no      | **yes** | **yes** | **yes** |


## Issues

Please file any issues or suggestions [on GitHub](https://github.com/hercules-team/augeasprovider-shellvar/issues).
