#!/bin/sh
#############################################################-*-tcl-*-
# NAME
#   rpt - rapid prototyping, generates a tcl/tk script, Version 2.04
#
# SYNOPSIS
#   rpt inFile [outFile]
#
# DESCRIPTION
#   This script generates a tcl/tk gui from an input file (inFile) and
#   writes its code to outFile. If outFile is omitted, it defaults to
#   [file rootname $inFile].tk (<-- that's tcl syntax). If outFile is
#   '-', the output goes to stdout, allowing to send the whole bunch
#   in a pipe.  The generated gui will work immediately after
#   generation but makes not much sense without some editing.
#
#   The input file has a very easy syntax. You just have to write down
#   the labels of the widgets you want to appear in the
#   gui. Additional you have to define the widget class. This is done
#   by adding one or two characters and one underscore '_' as a prefix to the
#   label. See section WIDGET PREFIXES for more info on that. One line
#   in the input file gives one frame with widgets aligned
#   horizontal. A new line in the input file starts a new frame in the
#   gui beneath the last one.
#
#   If you like to configure the global options of the widgets you may
#   do so by putting the options stuff in your ~/.Xdefaults file (see
#   section RESOURCES).
#
#   Alternatively you may use the 'opt <class> <list>' command. It is
#   followed by ONE character defining the widget class and a list
#   defining the options. Giving an asterix ('*') as class will add
#   this option to ALL widget classes. Since this is used to generate
#   an 'option add' line in the output file, this is case
#   sensitive. An example says more than millon words:
#
#   The command line
#     opt b {background Red relief raised}
#   will set the background color of all buttons to 'Red' and the
#   relief of all buttons to 'raised'.
#
#   Another way of configuring widget options is the 'set opt(<class>)
#   <string>' command. This will add the given string to every widget
#   of the given class defined after this command. The string '""'
#   resets this. And again an example:
#
#   The commands
#     set opt(r) "-relief flat -width 5"
#     b_HitMe r_black r_red r_gold
#     set opt(r) ""
#
#   will produce one normal button with default settings and three flat
#   radiobuttons with width 5. All succeeding radiobuttons will again
#   have the default options.
#
#   The fourth way of configuring individual widget options is the 'cfg
#   <widget> <string>' command. This will configure an already defined
#   widget. Be sure to first define the widget before using the 'cfg'
#   command. This is most usefull to configure the applications main
#   toplevel window '.'. And a last example:
#   The command
#     cfg . "-background grey80"
#   will set the background color of the toplevel '.' to grey80.
#
#   Every widget where it's applicable will have its own dedicated
#   procedure. The name of the procedure is the value of the prefix
#   given (by 'set prefix <value>') plus the label of the widget.
#   Well, in menus it is a little bit more complicated (see section
#   MENUS). Every set of radiobuttons in one row will only have one
#   procedure. The radiobutton's values are parameters to the
#   procedure.
#
#   The order of the outputfile will be:
#     Header                            - fixed
#     Your comments, options and code   - '#', 'opt', and '-' commands
#     Functions                         - 'menu' and widget commands
#     Widgets                           - 'menu' and widget commands
#     Bindings                          - if widget is used
#     Epilog signature                  - fixed
#
# COMMANDS
#   The following commands are allowed in the input file. More may be
#   added as soon as I get feedback from the world wide user
#   community.
#
#     #<anything>               - is a comment
#     -<anything>               - this will output <anything>
#     <anything>\               - continue this line in next input line
#     <list>                    - a set of vertical aligned widgets
#     <string>                  - a set of horizontal aligned widgets
#     cfg <widget> <string>     - configure a single existing widget
#     menu <list>               - defines a simple menu
#     opt <class> <list>        - sets global widget options for <class>
#     set opt(<class>) <string> - sets options for widget<class>
#     set prefix <value>        - sets prefix to all generated functions
#
#   Lists have to be in tcl syntax, don't forget the curly braces.
#
# COMMENTS
#   All your comments in the input file will be written right below
#   the standard rpt header of the output file.
#
# WIDGET PREFIXES
#   The following widget shortcots are allowed in the input file. Some
#   of these are obsolete and may not be supported any longer in later
#   versions. If the name given to a widget starts with a capital letter
#   you may skip the underscore.
#
#     one char defining the class
#     |   prefix
#     |   |     class name
#     |   |     |            remarks
#     |   |     |            |
#         a_    Canvas       obsolete, use 'cv' instead
#         g_    Message      obsolete, use 'ms' instead
#         m_    Menubutton   obsolete, use 'mb' instead
#         o_    Scrollbar    obsolete, use 'sb' instead
#         x_    Listbox      obsolete, use 'lb' instead
#     *         (all)        for opt command only
#     b   b_    Button
#     c   c_    CheckButton
#     cv  cv_   Canvas       no procedures
#     e   e_    Entry
#     f         Frame        no procedures
#     l   l_    Label        no procedures
#     lb  lb_   Listbox      no procedures
#     lo  lo_   Label        with textvariable (output label)
#     mb  mb_   Menubutton   no menus definable
#     ms  ms_   Message      no procedures
#     p         (Packer)     for 'set opt(p)'  only
#     pf        (Packer)     for 'set opt(pf)' only
#     r   r_    Radiobutton
#     s   s_    Scale
#     sb  sb_   Scrollbar
#     t   t_    Text         no procedures
#
# PACKING
#   All widgets of one row are packed in only one pack command. If you
#   want to change the behaviour of the packer you may set options
#   with the `set opt(p) <string>` command. This will only affect
#   widgets and NOT the surrounding frames.
#
#   If you want to change the packing of surrounding frames you may
#   set options with the `set opt(pf) <string>` command. This will
#   only affect the surrounding frames and NOT the widgets.
#
#   Packer options are ignored in menues.
#
#   If you use nested lists of widgets then the orientation of packing
#   alternated between '-side left' and '-side top'. If you need more
#   than one line in your editor to define a set of alternating
#   orientated widgets you may split it in multiple lines but don't
#   forget the backslash at each line's end! Here's a simple example:
#     {{bA bB} {bC bD}} {bE bF}
#   will produce buttons like this:
#     +---+  +---+  +---+
#     | A |  | B |  | E |
#     +---+  +---+  +---+
#     +---+  +---+  +---+
#     | C |  | D |  | F |
#     +---+  +---+  +---+
#
# MENUS
#   Menus are created with the 'menu <list>' command. The list
#   consists of an alternating set of menubuton labels and menu
#   entries. If you have more than one menu entry (which will be
#   normally the case) you have to enclose them all in a list.
#   Cascaded menues have the same syntax ans the main menu has.  Only
#   one level of cascaded menus is supported. Only checkbuttons and
#   radiobuttons need the widget prefixes 'c_' and 'r_' resp. And
#   here's a simple example:
#   The command
#
#     menu {File {Save Quit}\
#           Options {c_Debug {FontSize {r_10 r_12 r_14}}}\
#           Help {Index About}}
#
#   will produce a menu like this:
#
#     File    Options     Help
#      Save    []Debug     Index
#      Quit    FontSize    About
#                <>10
#		 <>12
#		 <>14
#
#   Every menu widget will have its own dedicated procedure. The name
#   of the procedure is the value of the prefix given (by 'set prefix
#   <value>') plus the label of the main menubutton plus the name of
#   the cascaded menubutton (if any) plus the name of the menu entry
#   itsef. Every set of radiobuttons will only have one procedure
#   which name is the value of the prefix plus the label of the main
#   menubutton plus the name of the cascaded menubutton (if any). The
#   radiobutton's values are parameters to the procedure.  Too
#   complicated? The above example produces the following procedures
#   (assuming the prefix is set to 'rpt'):
#
#     rptFileSave
#     rptFileQuit
#     rptOptionsDebug
#     rptOptionsFontSize
#     rptHelpIndex
#     rptHelpAbout
#
#   Oh, that was easy, wasn't it?
#
# RESOURCES
#   Since we define '-name wish' in the calling of the output file,
#   the options of the standard wish are used.
#
# CAVEATS
#   You should be familiar with Tcl/Tk.
#
#   You have to have Tcl/Tk installed on your computer.
#
#   The naming of procedures and widgets leads to conflicts if you try
#   to define more than one widget with the same name (except in
#   menus). If you know an easy workaround, send me an e-mail, please.
#
#   If you look at the source of rpt don't be irritated by the huge
#   amount of comments. Some are there to comment rpt, others are
#   there to comment the generated file.
#
# EXAMPLE
#   Write this to a file called 'test':
#     set prefix rpt
#     opt * {background grey80 activeBackground grey70}
#     cfg . "-background grey80"
#     menu {}
#     l_Channel r_ABC r_AFN r_CNN r_NBC
#     c_stereo c_Dolby c_Mute
#     l_Font e_Font
#     l_Fontsize e_Fontsize
#     l_Fontweight e_Fontweight
#     set opt(b) "-foreground red"
#     b_EXIT
#   And then just type 'atkRpt test'
#
# BUGS
#   There may be a lot of it. The rpt project has just started. So
#   please be patient ... and send me an bug report, please.
#
# DEDICATION
#   This program is dedicated to Rainer Koehler who just finished his
#   30. orbit around sun when this routine was born. The sun is an
#   ordinary yellowish G2 star in the center of our solar system,
#   which by itself is somewhere far out in the unfashionable
#   backwaters of the galaxy called 'Milkiway'. This is stupid because
#   it is not made out of milk but mainly Hydrogen and some crud.
#   Hydrogen is a tasteless and invisible gas that happens to turn
#   into lifeforms if you wait long enough.  ... sometimes I wonder if
#   I'm on the right planet.
#
# AUTHOR
#    @(#) Andreas Tusche (tusche@mpia-hd.mpg.de)
#
# COPYRIGHT
#   The whole atk library (including atkRpt) is shareware. This means
#   you can download the files for free, install them, test the
#   software, and give away copies for free. But if you want to use
#   it, you have to buy it.
#
#   European educational and non-profit organizations may use it for
#   free but are required to send a postcard to the author.  So, if
#   you have any wishes for further releases and want to support the
#   development of atkRpt, register now! The registration fee for
#   atkRpt is 3 ECU (three Euro) for European users and 5 $ (five US
#   dollars) for the rest of this planet.
#
#   So, why should you buy atkRpt if it's still under development?
#
#   - You can see what you will get for your money. The software
#     is getting better with each update.
#   - Most of the software you are using is still under development
#     and contains plenty of bugs. This is true even or especially
#     for commercial products.
#   - The updates on atkRpt are free! So you don't loose anything by
#     registering now.
#   - Getting money for the work encourages the author to do a better
#     job.
#   - Getting response makes development faster (believe it or not).
#
#   If you don't think atkPrt is worth the money, send me a postcard
#   and tell me what could make atkRpt a better program.
#
#   Send your check for 5 $ to:
#
#     Andreas Tusche
#     MPIA
#     Koenigstuhl 17
#     D 69117 Heidelberg
#     GERMANY
#
# MODIFICATION HISTORY
#     when       who       what (and Credits)
#     ---------  --------  ---------------------------------------------
#     04.Jun.97  A.Tusche  created
#     04.Jun.97  A.Tusche  added options stuff (RaKo)
#     10.Jun.97  A.Tusche  oops, forgot to set frame options (RaKo)
#     11.Jun.97  A.Tusche  comments moved, packer options (RaKo)
#     11.Jun.97  A.Tusche  entry binding, new command '-', .Xdefaults
#     14.Jun.97  A.Tusche  pack uses now '-in' option, new opt(pf)
#     24.Jun.97  A.Tusche  alternating pack directions

######################################################################
# ToDo
# - Listbox und Scrollbar sollten schon miteinander verbunden sein.
# - Prozeduren alphabetisch sortiert ausgeben
# - Menu seperator
# - Kommentar auch ohne Menu
# - Falls nur ein Widget in einer Zeile, keinen Rahmen drumherum
# - Defaultwerte fuer V() array
# - toplevel-widget fuer nachfolgende Widgets vogeben
# - Parent-widget fuer nachfolgende Widgets vogeben

# ====================================================================
# restart using wish
# ===================================================================\
exec wish "$0" "$@" -name wish

# command line options
switch $argc {
    1 {
	set inFile $argv
	set outFile [file rootname $argv].tk
	set o [open $outFile w]
    }
    2 {
	set inFile [lindex $argv 0]
	set outFile [lindex $argv 1]
	if {"$outFile" == "-"} {
	    set outFile stdout
	    set o stdout
	} else {
	    set o [open $outFile w]
	}
    }
    default {
	puts "USAGE: rpt <infile> \[outFile\]"
	puts "       if outFile is '-' output goes to stdout"
	exit
    }
}

# some defaults
set cnt(frame) 0
set cnt(menu) 0
set cnt(lastRadioFrame) 0
set cnt(radio) 0
set str(-) "# --------------------------------------------------------------------"
set str(=) "# ===================================================================="
set defaultmenu {File {Load Save SaveAs Quit} Options {c_Debug c_Verbose {Font {r_Charter r_Courier r_Helvetica}} {Fontsize {r_8 r_10 r_12 r_14 r_18 r_24}} {Fontweight {r_Bold r_Medium}}} Help {Index About}}
set prefix "rpt_"

foreach i {b c cv e f l lb lo mb ms p pf r s sb t} {
    set opt(${i}) ""
    set used(${i}) 0
}

set class(b)  Button
set class(c)  CheckButton
set class(cv) Canvas
set class(e)  Entry
set class(f)  Frame
set class(l)  Label
set class(lb) Listbox
set class(lo) Label
set class(mb) Menubutton
set class(ms) Message
set class(r)  Radiobutton
set class(s)  Scale
set class(sb) Scrollbar
set class(t)  Text

set opt(PACKSIDE) left

# ====================================================================
#  Procedures
# ====================================================================

# --------------------------------------------------------------------
#  rpt - one frame per line
# --------------------------------------------------------------------
proc rpt {{parent ""} {functionsonly 0} args} {
    global class cnt o opt prefix str used

    if {"$args" == ""} return

    set lastprocname ""
    if ![info exists cnt(frame$parent)] {set cnt(frame$parent) 0}
    incr cnt(frame$parent)
    set framename ${parent}.f$cnt(frame$parent)

    if $functionsonly {

	# ------------------------------------------------------------
	# output functions (and increment widget counter)
	# ------------------------------------------------------------

	foreach i $args {
	    if {[llength $i] > 1} {
		eval rpt $framename $functionsonly $i
		continue
	    }

	    # regexp {([a-z][a-z]?)(_?)(.*)} $i X type X name
	    set idx [string first "_" $i]
	    set type [string range $i 0 [expr $idx - 1]]
	    set name [string range $i [expr $idx + 1] end]
	    switch $type {
		b  {
		    incr used(b)
		    puts $o "\n\n$str(-)\n#  $prefix$name - for $class($type) $type$name\n$str(-)\n"
		    puts $o "proc $prefix$name {} {"
		    puts $o "    global OPT V"
		    puts $o "    if \$OPT(debug) {puts \"DEBUG: ${prefix}${name}()\"}"
		    puts $o "}"
		}
		c  {
		    incr used(c)
		    puts $o "\n\n$str(-)\n#  $prefix$name - for $class($type) $type${name}, variable V($name) \n$str(-)\n"
		    puts $o "proc $prefix$name {val} {"
		    puts $o "    global OPT V"
		    puts $o "    if \$OPT(debug) {puts \"DEBUG: ${prefix}${name}(\$val)\"}"
		    puts $o "}"
		}
		a  -
                cv {incr used(cv)}
		e  {
		    incr used(e)
		    puts $o "\n\n$str(-)\n#  $prefix$name - for $class($type) $type${name}, textvariable V($name)\n$str(-)\n"
		    puts $o "proc $prefix$name {val} {"
		    puts $o "    global OPT V"
		    puts $o "    if \$OPT(debug) {puts \"DEBUG: ${prefix}${name}(\$val)\"}"
		    puts $o "}"
		}
		f  {incr used(f)}
		l  {incr used(l)}
		x  -
		lb {incr used(lb)}
		lo {incr used(lo)}
		m  -
		mb {incr used(mb)}
		g  -
		ms {incr used(ms)}
		r  {
		    incr used(r)
		    if {"$cnt(lastRadioFrame)" != "$framename"} {
			incr cnt(radio)
			set cnt(lastRadioFrame) $framename
		    }
		    set newprocname ${prefix}Radio$cnt(radio)
		    if {"$lastprocname" != "$newprocname"} {
			puts $o "\n\n$str(-)\n#  ${newprocname} - for $class($type)s in frame $framename, variable V(r$cnt(radio))\n$str(-)\n"
			puts $o "proc ${newprocname} {val} {"
			puts $o "    global OPT V"
			puts $o "    if \$OPT(debug) {puts \"DEBUG: ${newprocname}(\$val)\"}"
			puts $o "}"
		    }
		    set lastprocname $newprocname
		}
		s {
		    incr used(s)
		    puts $o "\n\n$str(-)\n#  $prefix$name - for $class($type) $type${name}, variable V($name)\n$str(-)\n"
		    puts $o "proc $prefix$name {val} {"
		    puts $o "    global OPT V"
		    puts $o "    if \$OPT(debug) {puts \"DEBUG: ${prefix}${name}(\$val)\"}"
		    puts $o "}"
		}
		o  -
		sb {
		    incr used(sb)
		    puts $o "\n\n$str(-)\n#  ${prefix}Scroll${name} - for $class($type) $type${name}\n$str(-)\n"
		    puts $o "proc ${prefix}Scroll${name} {args} {"
		    puts $o "    global OPT V"
		    puts $o "    if \$OPT(debug) {puts \"DEBUG: ${prefix}Scroll${name}(\$args)\"}"
		    puts $o "}"
		}
		t {incr used(t)}
		default {puts $o "# ERROR in input file: $i"}
	    }
	}
    } else {

	# ------------------------------------------------------------
	# output widget definitions
	# ------------------------------------------------------------

	puts $o "frame       $framename $opt(f)"
	set packlist {}
	foreach i $args {
	    if {[llength $i] > 1} {
		switch $opt(PACKSIDE) {
		    top  {set opt(PACKSIDE) left}
		    left {set opt(PACKSIDE) top}
		}
		eval lappend packlist \[rpt $framename $functionsonly $i\]
		continue
	    }

	    #regexp {([a-z][a-z]?)(_?)([-+0-9A-Z].*)} $i X type X name
	    set idx [string first "_" $i]
	    set type [string range $i 0 [expr $idx - 1]]
	    set name [string range $i [expr $idx + 1] end]
	    lappend packlist .$type$name
	    switch $type {
		b  {puts $o "button      .b$name $opt(b) -text $name -command $prefix$name"}
		c  {puts $o "checkbutton .c$name $opt(c) -text $name -variable V($name) -command \{$prefix$name \$V($name)\}"}
		a  -
		cv {puts $o "canvas      .cv$name $opt(cv)"}
		e  {puts $o "entry       .e$name $opt(e) -textvariable V($name)"}
		f  {puts $o "frame       .f$name $opt(f)"}
		l  {puts $o "label       .l$name $opt(l) -text $name"}
		x  -
		lb {puts $o "listbox     .lb$name $opt(lb)"}
		lo {puts $o "label       .lo$name $opt(lo) -textvariable V($name)"}
		m  -
                mb {puts $o "menubutton  .mb$name $opt(mb) -text $name"}
		g  -
		ms {puts $o "message     .ms$name $opt(ms) -textvariable V($name)"}
		r  {
		    if {"$cnt(lastRadioFrame)" != "$framename"} {
			incr cnt(radio)
			set cnt(lastRadioFrame) $framename
		    }
		    puts $o "radiobutton .r$name $opt(r) -text $name -value $name -variable V(r$cnt(radio)) -command \"${prefix}Radio$cnt(radio) $name\""
		}
		s  {puts $o "scale       .s$name $opt(s) -label $name -variable V($name) -command $prefix$name"}
		o  -
		sb {puts $o "scrollbar   .sb$name $opt(sb) -command ${prefix}Scroll$name"}
		t  {puts $o "text        .t$name $opt(t)"}
		default {puts $o "# ERROR in input file: $i"}
	    }
	}
	puts $o "pack        $packlist -in $framename -side $opt(PACKSIDE) $opt(p)"
	if {"$parent" == ""} {
	    puts $o "pack        $framename $opt(pf)\n"
	    set opt(PACKSIDE) left
	} else {
	    switch $opt(PACKSIDE) {
		top  {set opt(PACKSIDE) left}
		left {set opt(PACKSIDE) top}
	    }
	    return $framename
	}
    }
}


# --------------------------------------------------------------------
#  rptcfg
# --------------------------------------------------------------------
proc rptcfg {wdg val {functionsonly 0}} {
    global o
    puts $o "$wdg configure $val"
}

# --------------------------------------------------------------------
#  rptmenu - generates a menu and related functions
# --------------------------------------------------------------------

proc rptmenu {inList {functionsonly 0}} {
    global cnt defaultmenu o opt prefix str

    if {"$inList" == {}} {
	set list $defaultmenu
    } else {
	set list $inList
    }

    set lastprocname ""
    incr cnt(menu)
    set w .menu$cnt(menu)
    if $functionsonly {
	puts $o "\n$str(=)\n#  Menu related procedures\n$str(=)"
    } else {
	puts $o "\n$str(-)\n#  define menu\n$str(-)\n"
    }
    if !$functionsonly {
	puts $o "frame $w $opt(f)"
    }
    for {set i 0} {$i < [llength $list]} {incr i 2} {
	set cmd1 [lindex $list $i]
	set list2 [lindex $list [expr $i + 1]]

	# ------------------------------------------------------------
	# menu bar buttons
	# ------------------------------------------------------------
	if !$functionsonly {
	    puts $o "\n# $cmd1"
	    puts $o "menubutton $w.m$cmd1 -menu $w.m$cmd1.m -relief flat -text $cmd1"
	    puts $o "menu $w.m$cmd1.m"
	}

	foreach l2 $list2 {
	    if {[llength $l2] > 1} {
		# ----------------------------------------------------
		# have a cascaded menu
		# ----------------------------------------------------
		set cmd2 [lindex $l2 0]
		set list3 [lindex $l2 1]
		if !$functionsonly {
		    puts $o "\n$w.m$cmd1.m add cascade -label $cmd2 -menu $w.m$cmd1.m.m$cmd2"
		    puts $o "menu $w.m$cmd1.m.m$cmd2"
		}

		foreach l3 $list3 {
		    set cmd3 $l3
		    switch [string range $cmd3 0 1] {
			# -
			#_checkbutton -
			"c_" {
			    set cmd3 [string range $cmd3 2 end]
			    if $functionsonly {
				puts $o "\n\n$str(-)\n#  ${prefix}${cmd1}${cmd2}${cmd3}\n$str(-)\n"
				puts $o "proc ${prefix}${cmd1}${cmd2}${cmd3} {val} {"
				puts $o "    global OPT V"
				puts $o "    if \$OPT(debug) {puts \"DEBUG: ${prefix}${cmd1}${cmd2}${cmd3}(\$val)\"}"
				puts $o "}"
			    } else {
				puts $o "$w.m$cmd1.m.m$cmd2 add checkbutton -label $cmd3 -variable V($cmd3) -command \{${prefix}${cmd1}${cmd2}${cmd3} \$V($cmd3)\}"
			    }
			}
			# -
			#_radiobutton -
			"r_" {
			    set cmd3 [string range $cmd3 2 end]
			    if $functionsonly {
				set newprocname ${prefix}${cmd1}${cmd2}
				if {"$lastprocname" != "$newprocname"} {
				    puts $o "\n\n$str(-)\n#  ${newprocname}\n$str(-)\n"
				    puts $o "proc ${newprocname} {val} {"
				    puts $o "    global OPT V"
				    puts $o "    if \$OPT(debug) {puts \"DEBUG: ${newprocname}(\$val)\"}"
				    puts $o "}"
				}
				set lastprocname $newprocname
			    } else {
				puts $o "$w.m$cmd1.m.m$cmd2 add radiobutton -label $cmd3 -value $cmd3 -variable V($cmd2) -command \"${prefix}${cmd1}${cmd2} ${cmd3}\""
			    }
			}
			# -
			#_command -
			default {
			    if $functionsonly {
				puts $o "\n\n$str(-)\n#  ${prefix}${cmd1}${cmd2}${cmd3}\n$str(-)\n"
				puts $o "proc ${prefix}${cmd1}${cmd2}${cmd3} {} {"
				puts $o "    global OPT V"
				puts $o "    if \$OPT(debug) {puts \"DEBUG: ${prefix}${cmd1}${cmd2}${cmd3}()\"}"
				puts $o "}"
			    } else {
				puts $o "$w.m$cmd1.m.m$cmd2 add command -label $cmd3 -command ${prefix}${cmd1}${cmd2}${cmd3}"
			    }
			}
		    }
		}

	    } else {
		# ----------------------------------------------------
		# have NO cascaded menu
		# ----------------------------------------------------
		set cmd2 $l2
		switch [string range $cmd2 0 1] {
		    # -
		    #_checkbutton -
		    "c_" {
			set cmd2 [string range $cmd2 2 end]
			if $functionsonly {
			    puts $o "\n\n$str(-)\n#  ${prefix}${cmd1}${cmd2}\n$str(-)\n"
			    puts $o "proc ${prefix}${cmd1}${cmd2} {val} {"
			    puts $o "    global OPT V"
			    puts $o "    if \$OPT(debug) {puts \"DEBUG: ${prefix}${cmd1}${cmd2}(\$val)\"}"
			    puts $o "}"
			} else {
			    puts $o "$w.m$cmd1.m add checkbutton -label $cmd2 -variable V($cmd2) -command \{${prefix}${cmd1}${cmd2} \$V($cmd2)\}"
			}
		    }
		    # -
		    #_radiobutton -
		    "r_" {
			set cmd2 [string range $cmd2 2 end]
			if $functionsonly {
			    set newprocname ${prefix}${cmd1}
			    if {"$lastprocname" != "$newprocname"} {
				puts $o "\n\n$str(-)\n#  ${newprocname}\n$str(-)\n"
				puts $o "proc ${newprocname} {val} {"
				puts $o "    global OPT V"
				puts $o "    if \$OPT(debug) {puts \"DEBUG: ${newprocname}(\$val)\"}"
				puts $o "}"
			    }
			    set lastprocname $newprocname
			} else {
			    puts $o "$w.m$cmd1.m add radiobutton -label $cmd2 -value $cmd2 -variable V($cmd1) -command \"${prefix}${cmd1} ${cmd2}\""
			}
		    }
		    # -
		    #_command -
		    default {
			if $functionsonly {
			    puts $o "\n\n$str(-)\n#  ${prefix}${cmd1}${cmd2}\n$str(-)\n"
			    puts $o "proc ${prefix}${cmd1}${cmd2} {} {"
			    puts $o "    global OPT V"
			    puts $o "    if \$OPT(debug) {puts \"DEBUG: ${prefix}${cmd1}${cmd2}()\"}"
			    puts $o "}"
			} else {
			    puts $o "$w.m$cmd1.m add command -label $cmd2 -command ${prefix}${cmd1}${cmd2}"
			}
		    }
		}
	    }
	}
	if !$functionsonly {
	    puts $o "pack $w.m$cmd1 -side left"
	}
    }
    if !$functionsonly {
	puts $o "pack $w -expand 1 -fill x"
    }

    if $functionsonly {
	puts $o "\n\n$str(=)\n#  Widget related Procedures\n$str(=)"
    } else {
	puts $o "\n$str(-)\n#  Define other widgets\n$str(-)\n"
    }
}


# --------------------------------------------------------------------
#  rptopt
# --------------------------------------------------------------------
proc rptopt {wdg val {functionsonly 0}} {
    global class o

    if {$wdg == "*"} {
	for {set i 0} {$i < [llength $val]} {incr i 2} {
	    puts $o "option add *[lindex $val $i] [lindex $val [expr $i + 1]]"
	}
    } else {
	for {set i 0} {$i < [llength $val]} {incr i 2} {
	    puts $o "option add *$class($wdg)*[lindex $val $i] [lindex $val [expr $i + 1]]"
	}
    }
}

# --------------------------------------------------------------------
#  rptset
# --------------------------------------------------------------------
proc rptset {name val {functionsonly 0}} {
    if $functionsonly {
	if {[string range $name 0 2] == "opt"} return
    }
    upvar $name var
    set var $val
}

# ====================================================================
#  MAIN
# ====================================================================

puts $o "#!/bin/sh
#============================================================-*-tcl-*-
# NAME
#   $outFile -
#
# SYNOPSIS
#   $outFile
#
# DESCRIPTION
#   read the source :-)
#
#   OPT  - array of user defined options (debug, verbose, colors, ...)
#   PRIV - array of application's private values to remember
#   V    - array of widget related variables
#
# AUTHOR
#   This file was automatically generated by rpt
#
$str(=)
# ToDo
# - give some sense to the functions

$str(-)
# MODIFICATION HISTORY
#   when      who       what
#   --------- --------- ---------------------------------------------
#   [exec date +%d.%m.%y]  [string range "$env(USER)         " 0 8 ] created with rpt ((C) by tusche@mpia-hd.mpg.de)

$str(=)
# restart using wish
# ===================================================================\\
exec wish \"\$0\" \"\$@\" -name wish

set OPT(debug) 1
"


# --------------------------------------------------------------------
#  Phase1 - Write additional code, options, and all comments
# --------------------------------------------------------------------
foreach an [array names cnt] {set cnt($an) 0}
set fid [open $inFile r]
while {![eof $fid]} {
    set zeile [string trim [gets $fid]]
    while {[string range $zeile  [expr [string length $zeile] - 1 ] end] == "\\"} {
	set zeile "[string range $zeile 0 [expr [string length $zeile] - 2 ]] [string trim [gets $fid]]"
    }
    switch -regexp -- "$zeile" {
	"^#.*$"    {puts $o $zeile}
	"^-.*$"    {puts $o [string range $zeile 1 end]}
	"^opt.*$"  {eval rpt$zeile}
	default    {}
    }
}
close $fid


# --------------------------------------------------------------------
#  Phase2 - Write functions
# --------------------------------------------------------------------
foreach an [array names cnt] {set cnt($an) 0}
set fid [open $inFile r]
while {![eof $fid]} {
    set zeile [string trim [gets $fid]]
    while {[string range $zeile  [expr [string length $zeile] - 1 ] end] == "\\"} {
	set zeile "[string range $zeile 0 [expr [string length $zeile] - 2 ]] [string trim [gets $fid]]"
    }
    switch -regexp -- "$zeile" {
	"^#.*$"    {}
	"^-.*$"    {}
	"^\{.*$"   {eval rpt \"\" 1 $zeile}
	"^cfg.*$"  {}
	"^menu.*$" {eval rpt$zeile 1}
	"^opt.*$"  {}
	"^set.*$"  {eval rpt$zeile 1}
	default    {eval rpt \"\" 1 $zeile}
    }
}
close $fid


# --------------------------------------------------------------------
#  Phase3 - Write widgets
# --------------------------------------------------------------------
puts $o "\n$str(=)\n# Define widgets\n$str(=)\n"
foreach an [array names cnt] {set cnt($an) 0}
set fid [open $inFile r]
while {![eof $fid]} {
    set zeile [string trim [gets $fid]]
    while {[string range $zeile  [expr [string length $zeile] - 1 ] end] == "\\"} {
	set zeile "[string range $zeile 0 [expr [string length $zeile] - 2 ]] [string trim [gets $fid]]"
    }
    switch -regexp -- "$zeile" {
	"^#.*$"    {}
	"^-.*$"    {}
	"^\{.*$"   {eval rpt \"\" 0 $zeile}
	"^cfg.*$"  -
	"^menu.*$" -
	"^set.*$"  {eval rpt$zeile}
	"^opt.*$"  {}
	default    {eval rpt \"\" 0 $zeile}
    }
}


# --------------------------------------------------------------------
#  Write bindings
# --------------------------------------------------------------------

puts $o "\n$str(=)\n# Some bindings\n$str(=)\n"

# if $used(b) {
#     puts $o ""
# }
#
# if $used(c) {
#     puts $o ""
# }
# if $used(cv) {
#     puts $o ""
# }
#

if $used(e) {
    puts $o "
bind Entry <Return> {
    global V
    set name \[string range \[file extension %W\] 2 end\]
    ${prefix}\$name \$V(\$name)
}
"
}

# if $used(f) {
#     puts $o ""
# }
#
# if $used(l) {
#     puts $o ""
# }
#
# if $used(lb) {
#     puts $o ""
# }
#
# if $used(mb) {
#     puts $o ""
# }
#
# if $used(ms) {
#     puts $o ""
# }
#
# if $used(r) {
#     puts $o ""
# }
#
# if $used(s) {
#     puts $o ""
# }
#
# if $used(sb) {
#     puts $o ""
# }
#
# if $used(t) {
#     puts $o ""
# }
#


# --------------------------------------------------------------------
#  Epilog
# --------------------------------------------------------------------

puts $o "
#     _/_/_/_/  _/_/_/_/  _/_/_/_/_/
#    _/    _/  _/    _/      _/
#   _/_/_/_/  _/_/_/_/      _/
#  _/  _/    _/            _/
# _/    _/  _/            _/  (C) by AnTu
"
close $fid
close $o

if {"$outFile" != "stdout"} {
    exec chmod 750 $outFile
    exec ./$outFile &
}

exit

#
#     _/_/_/_/        _/_/_/_/_/
#    _/    _/            _/
#   _/_/_/_/  _/_/_/_/  _/  _/    _/
#  _/    _/  _/    _/  _/  _/    _/
# _/    _/  _/    _/  _/  _/_/_/_/

