#############################################################-*-tcl-*-
#  NAME
#    labelentry - Create and manipulate labeld entry widgets
#
#  SYNOPSIS
#    labelentry pathName ?options?
#
#  DESCRIPTION
#    The shorthelp command creates three new windows
#      pathName    a frame widet
#      pathName.l  a label widget
#      pathName.e  an entry widget
#
#    Additional options, described below, may be specified on the
#    command line or in the option database to configure aspects of
#    the labelentry. The labelentry command returns its pathName
#    argument.  At the time this command is invoked, there must not
#    exist a window named pathName, but pathName's parent must exist.
#
#    A labelentry is a widget that displays a one-line editable text
#    string in an entry widget and a static text nearby in a label
#    widget. See the "entry" and "frame" manpages for details.
#
#  STANDARD OPTIONS
#    Nearly all standard options of entries, frames and labels may be
#    used:
#      				entry (pathName.e)
#      				| frame (pathName)
#      				| | label (pathName.l)
#      				| | |     remarks
#      anchor                       x
#      background               x
#      bd                       x
#      bg                       x
#      bitmap                       x
#      borderwidth              x
#      class                              not supported here
#      colormap                   x
#      cursor                   x x x
#      entrybackground          x         NEW atk option
#      entryborderwidth         x         NEW atk option
#      entrycursor              x         NEW atk option
#      entryforeground          x         NEW atk option
#      entryfont                x         NEW atk option
#      entryheight              x         NEW atk option
#      entryhighlightbackground x         NEW atk option
#      entryhighlightcolor      x         NEW atk option
#      entryhighlightthickness  x         NEW atk option
#      entryrelief              x         NEW atk option
#      entrytextvariable        x         NEW atk option
#      entrywidth               x         NEW atk option
#      exportSelection          x
#      fg                       x
#      font                     x   x
#      foreground               x
#      framebackground            x       NEW atk option
#      frameborderwidth           x       NEW atk option
#      framecursor                x       NEW atk option
#      frameforeground            x       NEW atk option
#      frameheight                x       NEW atk option
#      framehighlightbackground   x       NEW atk option
#      framehighlightcolor        x       NEW atk option
#      framehighlightthickness    x       NEW atk option
#      framerelief                x       NEW atk option
#      framewidth                 x       NEW atk option
#      height                     x
#      help                     x x x     NEW atk option (see below)
#      highlightBackground      x x x
#      highlightColor           x x x
#      highlightThickness       x x x
#      image                        x
#      insertBackground         x
#      insertBorderWidth        x
#      insertOffTime            x
#      insertOnTime             x
#      insertWidth              x
#      justify                      x
#      labelbackground              x     NEW atk option
#      labelborderwidth             x     NEW atk option
#      labelcursor                  x     NEW atk option
#      labelfont                    x     NEW atk option
#      labelforeground              x     NEW atk option
#      labelheight                  x     NEW atk option
#      labelhighlightbackground     x     NEW atk option
#      labelhighlightcolor          x     NEW atk option
#      labelhighlightthickness      x     NEW atk option
#      labelrelief                  x     NEW atk option
#      labeltextvariable            x     NEW atk option
#      labelwidth                   x     NEW atk option
#      padx                         x
#      pady                         x
#      relief                     x
#      selectbackground         x
#      selectborderwidth        x
#      selectforeground         x
#      show                     x
#      state                    x
#      takeFocus                x x x
#      text                         x
#      textvariable             x
#      underline                    x
#      visual                     x
#      width                    x
#      wrapLength                   x
#      xScrollCommand           x
#
#    See the "entry", "frame" and "label" manuals for details on the
#    standard options.
#
#  WIDGET-SPECIFIC OPTIONS
#      Name:                help
#      Class:               Text
#      Command-Line Switch: -help
#    Specifies the help text of this widget. If this option isn't
#    specified, the labelentry's short help defaults to "I'm proud to
#    be a short help widget". The help option may not be changed with
#    the configure widget command.
#
#  SUB-WIDGET OPTIONS
#    Options 'entryXXXXXX', 'frameXXXXXX' and 'labelXXXXX' configure
#    the entry, frame, and label sub-widgets resp. If you find
#    yourself using these options, you should consider to have some of
#    them defined in the option database. Options for the frame widget
#    (pathName) are defined in the option database with the following
#    command:
#      option add *LabelEntry*XXXXXX value
#    Options for the entry widget (pathName.e) are defined in the
#    option database with the following command:
#      option add *LabelEntry*e.XXXXXX value
#    Options for the label widget (pathName.l) are defined in the
#    option database with the following command:
#      option add *LabelEntry*l.XXXXXX value
#
#  WIDGET COMMAND
#    The labelentry command creates a new Tcl command whose name is
#    pathName.  This command may be used to invoke various operations
#    on the widget. It has the same general form as all entry widgets
#    have.
#    The 'cget' action as well as the 'configure' action without any
#    option return the options of the entry subwidget. If you want to
#    get options of the label subwidget, use the pathName.l command
#    instead.
#    The following actions are supported:
#      cget
#      configure
#      delete
#      get
#      icursor
#      index
#      insert
#      scan
#      selection
#      xview
#
#    See the "entry", "frame" and "label" manuals for details on the
#    standard widget actions.
#
#  BINDINGS
#    When a new labelentry is created, it has the same default event
#    bindings as entries have. See the "entry" manual for details on
#    the standard widget bindings.
#
#  EXAMPLES
#    labelentry .l -show "*" -text "Password:" -textvariable password
#
#  SEE ALSO
#    entry, frame, label
#
#  BUGS
#    If you find some, e-mail me please.
#
#  AUTHOR
#    @(#) Andreas Tusche (mailto:tusche@mpia-hd.mpg.de)
#
#  MODIFICATION HISTORY
#      11.May.97  A.Tusche  labelentry (preliminary version) created
#      21.May.97  A.Tusche  atkLabelEntryCmd, option database added
#=====================================================================
#  TODO
#  -
#

if ![info exists tkPriv(atk)] atkInit

#=====================================================================
# Option Database for LabelEntry
#=====================================================================

# frame and all descendants (options valid for frame)

option add *LabelEntry*background          $tkPriv(colBG)  $tkPriv(atkOptPri)
option add *LabelEntry*borderWidth         2               $tkPriv(atkOptPri)
option add *LabelEntry*colormap            .               $tkPriv(atkOptPri)
option add *LabelEntry*cursor              {}              $tkPriv(atkOptPri)
option add *LabelEntry*foreground          $tkPriv(colFG)  $tkPriv(atkOptPri)
option add *LabelEntry*height              0               $tkPriv(atkOptPri)
option add *LabelEntry*highlightBackground $tkPriv(colHIB) $tkPriv(atkOptPri)
option add *LabelEntry*highlightColor      $tkPriv(colHIC) $tkPriv(atkOptPri)
option add *LabelEntry*highlightThickness  0               $tkPriv(atkOptPri)
option add *LabelEntry*relief              flat            $tkPriv(atkOptPri)
option add *LabelEntry*takeFocus           0               $tkPriv(atkOptPri)
option add *LabelEntry*visual              {}              $tkPriv(atkOptPri)
option add *LabelEntry*width               0               $tkPriv(atkOptPri)

# all descendants (options not valid to frame but to some other)

option add *LabelEntry*anchor              w               $tkPriv(atkOptPri)
option add *LabelEntry*bitmap              {}              $tkPriv(atkOptPri)
option add *LabelEntry*exportSelection     true            $tkPriv(atkOptPri)
#option add *LabelEntry*font                fixed           $tkPriv(atkOptPri)
option add *LabelEntry*image               {}              $tkPriv(atkOptPri)
option add *LabelEntry*insertBackground    $tkPriv(colIBG) $tkPriv(atkOptPri)
option add *LabelEntry*insertBorderWidth   0               $tkPriv(atkOptPri)
option add *LabelEntry*insertOffTime       350             $tkPriv(atkOptPri)
option add *LabelEntry*insertOnTime        650             $tkPriv(atkOptPri)
option add *LabelEntry*insertWidth         2               $tkPriv(atkOptPri)
option add *LabelEntry*justify             left            $tkPriv(atkOptPri)
option add *LabelEntry*padX                0               $tkPriv(atkOptPri)
option add *LabelEntry*padY                0               $tkPriv(atkOptPri)
option add *LabelEntry*selectBackground    $tkPriv(colSBG) $tkPriv(atkOptPri)
option add *LabelEntry*selectBorderWidth   1               $tkPriv(atkOptPri)
option add *LabelEntry*selectForeground    $tkPriv(colSFG) $tkPriv(atkOptPri)
option add *LabelEntry*text                {}              $tkPriv(atkOptPri)
option add *LabelEntry*textVariable        {}              $tkPriv(atkOptPri)
option add *LabelEntry*underline           -1              $tkPriv(atkOptPri)
option add *LabelEntry*wrapLength          0               $tkPriv(atkOptPri)
option add *LabelEntry*xScrollCommand      {}              $tkPriv(atkOptPri)
option add *LabelEntry*show                {}              $tkPriv(atkOptPri)
option add *LabelEntry*state               normal          $tkPriv(atkOptPri)

# special descendants (options that differ from above definitions)

option add *LabelEntry*e.background        $tkPriv(colEBG) $tkPriv(atkOptPri)
option add *LabelEntry*e.relief            sunken          $tkPriv(atkOptPri)


#=====================================================================
# atkLabelEntryCmd - Handle widget related commands
#   w        original widget name (before it has been renamed)
#   argList  list of arguments
#=====================================================================

proc atkLabelEntryCmd {w argsList} {
    global tkPriv

    set cmd [lindex $argsList 0]
    set arg [lrange $argsList 1 end]
    set newname [atkNewWdgProcName $w]

    switch $cmd {
	cget  {
	    return [lindex [atkLabelEntryCmd $w "configure $arg"] 4]
	}

	configure {
	    set nArgs [llength $arg]

	    if {$nArgs == 0} {
		set out [eval $w.e $cmd]
		# help
		if [info exists tkPriv(shortHelpTextArray)] {
		    global $tkPriv(shortHelpTextArray)
		    lappend out "-help help Text {[set $tkPriv(shortHelpTextArray)($w)]}"
		} else {
		    lappend out "-help help Text {}"
		}
		return [lsort $out]
	    }

	    if {$nArgs == 1} {
		set opt [string range $arg 1 end]
		switch [string tolower $opt] {
		    help {
			if [info exists tkPriv(shortHelpTextArray)] {
			    global $tkPriv(shortHelpTextArray)
			    lappend out "-help help Text {[set $tkPriv(shortHelpTextArray)($w)]}"
			} else {
			    lappend out "-help help Text {}"
			}
		    }
		    #_default -
		    default {set out [eval $w.e $cmd $arg]}
		}
		return $out
	    }

	    # The following code only is executed if nArgs > 1
	    set eopts ""
	    set fopts ""
	    set lopts ""
	    for {set i 0} {$i < $nArgs} {incr i 2} {
		set opt [string range [lindex $arg $i] 1 end]
		set val [lindex $arg [expr $i + 1]]
		if {[string index $val 0] == "-"} {
		    error "value for \"$opt\" missing"
		}
		switch [string tolower $opt] {
		    #_options_for_all_widgets -
		    cursor -
		    highlightbackground -
		    highlightcolor -
		    highlightthickness -
		    takefocus {
			append eopts "-$opt $val "
			append fopts "-$opt $val "
			append lopts "-$opt $val "
		    }
		    #_entry_options -
		    bd -
		    bg -
		    exportselection -
		    fg -
		    insertbackground -
		    insertborderwidth -
		    insertofftime -
		    insertontime -
		    insertwidth -
		    selectbackground -
		    selectborderwidth -
		    selectforeground -
		    show -
		    state -
		    textvariable -
		    width -
		    xscrollcommand {append eopts "-$opt $val "}
		    #_entry_and_label_options -
		    font {
			append eopts "-$opt $val "
			append lopts "-$opt $val "
		    }
		    #_frame_and_label_options -
		    background -
		    borderwidth -
		    foreground {
			append fopts "-$opt $val "
			append lopts "-$opt $val "
		    }
		    #_frame_options -
		    colormap -
		    height -
		    relief -
		    visual {append fopts "-$opt $val "}
		    #_label_options -
		    anchor -
		    bitmap -
		    image -
		    justify -
		    padx -
		    pady -
		    text -
		    underline -
		    wraplength {append lopts "-$opt \"$val\" "}
		    #_special -
		    entryrelief {append eopts "-relief $val "}
		    help {
			global $tkPriv(shortHelpTextArray)
			set $tkPriv(shortHelpTextArray)($w)   $val
			set $tkPriv(shortHelpTextArray)($w.e) $val
			set $tkPriv(shortHelpTextArray)($w.l) $val
		    }
		    labelrelief {append lopts "-relief $val "}
		    #_default -
		    default {return -code error -errorinfo "Unknown or wrong option $opt"}
		}
	    }
	    eval $w.e $cmd $eopts
	    eval $newname $cmd $fopts
	    eval $w.l $cmd $lopts
	}

	delete -
	get -
	icursor -
	index -
	insert -
	scan -
	selection -
	xview {$w.e $cmd $arg}

	default {return -code error -errorinfo "Unknown command to ${w}: $cmd"}
    }
    return
}


#=====================================================================
#
#=====================================================================


proc labelentry {w args} {
    global tkPriv

    # create three widgets and pack them
    frame $w -class LabelEntry
    label $w.l
    entry $w.e
    pack $w.l $w.e -side left

    # change widget related procedure <-- this is the main trick!
    set newname [atkNewWdgProcName $w]
    rename $w $newname
    eval proc $w \{args\} \{atkLabelEntryCmd ${w} \$args \}

    # set some defaults, may be overwiritten by options
    $w.e configure -textvariable [string range [file extension $w] 1 end]
    $w.l configure -text [string range [file extension $w] 1 end]

    # and now configure the widgets
    atkLabelEntryCmd $w "configure $args"

    return $w
}


#
#     _/_/_/_/        _/_/_/_/_/
#    _/    _/            _/
#   _/_/_/_/  _/_/_/_/  _/  _/    _/
#  _/    _/  _/    _/  _/  _/    _/
# _/    _/  _/    _/  _/  _/_/_/_/












