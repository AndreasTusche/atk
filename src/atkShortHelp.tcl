#############################################################-*-tcl-*-
#  NAME
#    shorthelp - Create and manipulate short help widgets
#
#  SYNOPSIS
#    shorthelp pathName ?options?
#
#  DESCRIPTION
#    The shorthelp command creates two new windows
#      pathName        a frame widet
#      pathName.sHelp  a label widget
#
#    Additional options, described below, may be specified on the
#    command line or in the option database to configure aspects of
#    the shorthelp. The shorthelp command returns its pathName
#    argument.  At the time this command is invoked, there must not
#    exist a window named pathName, but pathName's parent must exist.
#
#    A shorthelp is a widget that displays a textual string describing
#    another widget of the same application. The text to display is
#    given by the "-help" option of the OTHER widget. If text is
#    displayed, it must all be in a single font, but it can occupy
#    multiple lines on the screen (if it contains newlines or if
#    wrapping occurs because of the wrapLength option) and one of the
#    characters may optionally be underlined using the underline
#    option.  The shorthelp can be manipulated in a few simple ways,
#    using the commands described below.
#
#    Actually the text to display is taken from a global array. The
#    Name of the array defaults to sHELP but may be changed with the
#    helparray option. The elements of the array have to be the
#    pathNames of the other widgets in the application.
#
#  STANDARD OPTIONS
#    Nearly all standard tk options of frames and labels may be
#    used. There are some additional options to configure the
#    sub-widgets seperatley.
#      				frame (pathName)
#      				| label (pathName.sHelp)
#      				| |     remarks
#      anchor                  	x
#      background              	x
#      bd                      	  x     (borderwidth)
#      bg                      	  x     (background)
#      bitmap                  	        not supported here
#      borderwidth             	x
#      class                    	not supported here
#      colormap                 x
#      cursor                   x x
#      fg                      	  x     (foreground)
#      font                    	  x
#      foreground              	  x
#      framebackground          x       NEW atk option
#      frameborderwidth         x       NEW atk option
#      framecursor              x       NEW atk option
#      frameforeground          x       NEW atk option
#      frameheight              x       NEW atk option
#      framehighlightbackground x       NEW atk option
#      framehighlightcolor      x       NEW atk option
#      framehighlightthickness  x       NEW atk option
#      framerelief              x       NEW atk option
#      framewidth               x       NEW atk option
#      height                  	x
#      help                    	x       NEW atk option (see below)
#      helparray                x x     NEW atk option (see below)
#      highlightbackground      x x
#      highlightcolor           x x
#      highlightthickness       x x
#      image                  	        not supported here
#      ipadX                   	x       NEW atk option (see below)
#      ipadY                   	x       NEW atk option (see below)
#      justify                	x
#      labelbackground         	  x     NEW atk option
#      labelborderwidth        	  x     NEW atk option
#      labelcursor                x     NEW atk option
#      labelforeground         	  x     NEW atk option
#      labelheight             	  x     NEW atk option
#      labelhighlightbackground   x     NEW atk option
#      labelhighlightcolor        x     NEW atk option
#      labelhighlightthickness    x     NEW atk option
#      labelrelief            	  x     NEW atk option
#      labelwidth             	  x     NEW atk option
#      padX                   	        here: packer option
#      padY                   	        here: packer option
#      relief                 	x
#      takeFocus                x x
#      text                   	        not supported here
#      textVariable           	x
#      underline              	x
#      visual                   x
#      width                  	x
#      wrapLength             	x
#
#    See the "frame" and "label" manuals for details on the standard
#    options.
#
#  WIDGET-SPECIFIC OPTIONS
#      Name:                help
#      Class:               Text
#      Command-Line Switch: -help
#    Specifies the help text of this widget. If this option isn't
#    specified, the shorthelp's short help defaults to "I'm proud to
#    be a short help widget". The help option may not be changed with
#    the configure widget command.
#
#      Name:                helparray
#      Class:               Variable
#      Command-Line Switch: -helparray
#    Specifies the name of a global array containing the help texts of
#    widgets. The Name of the array defaults to HELP but may be
#    changed with the helparray option. The elements of the array have
#    to be the pathNames of the other widgets in the application. The
#    helparray option may not be changed with the configure widget
#    command.
#
#      Name:                ipadX
#      Class:               Pad
#      Command-Line Switch: -ipadx
#    Specifies a non-negative value indicating how much extra space to
#    request for the text inside the label widget in the X-direction.
#    The value may have any of the forms acceptable to Tk_GetPixels.
#    When computing how large a window it needs, the widget will add
#    this amount to the width it would normally need (as determined by
#    the width of the text displayed in the widget); if the geometry
#    manager can satisfy this request, the widget will end up with
#    extra internal space to the left and right.
#
#      Name:               ipadY
#      Class:              Pad
#      Command-Line Switch: -ipady
#    Specifies a non-negative value indicating how much extra space to
#    request for the text inside the label widget in the Y-direction.
#    The value may have any of the forms acceptable to Tk_GetPixels.
#    When computing how large a window it needs, the widget will add
#    this amount to the height it would normally need (as determined
#    by the height of the text displayed in the widget); if the
#    geometry manager can satisfy this request, the widget will end up
#    with extra internal space above and below.
#
#      Name:                padX
#      Class:               Pad
#      Command-Line Switch: -padx
#    Specifies a non-negative value indicating how much extra space to
#    request for the label widget in the X-direction.  The value may
#    have any of the forms acceptable to Tk_GetPixels.  When computing
#    how large a window it needs, the widget will add this amount to
#    the width it would normally need (as determined by the width of
#    the things displayed in the widget); if the geometry manager can
#    satisfy this request, the widget will end up with extra internal
#    space to the left and right of the short help label.
#
#      Name:                padY
#      Class:               Pad
#      Command-Line Switch: -pady
#    Specifies a non-negative value indicating how much extra space to
#    request for the label widget in the Y-direction.  The value may
#    have any of the forms acceptable to Tk_GetPixels.  When computing
#    how large a window it needs, the widget will add this amount to
#    the height it would normally need (as determined by the height of
#    the things displayed in the widget); if the geometry manager can
#    satisfy this request, the widget will end up with extra internal
#    space above and below the short help label.
#
#  SUB-WIDGET OPTIONS
#    Options 'frameXXXXXX' and 'labelXXXXX' configure the frame and
#    label sub-widgets resp. If you find yourself using these options,
#    you should consider to have some of them defined in the option
#    database. Options for the frame widget (pathName) are defined in
#    the option database with the following command:
#      option add *ShortHelp*XXXXXX value
#    Options for the label widget (pathName.sHelp) are defined in the
#    option database with the following command:
#      option add *ShortHelp*sHelp.XXXXXX value
#
#  WIDGET COMMAND
#    The shorthelp command creates a new Tcl command whose name is
#    pathName.  This command may be used to invoke various operations
#    on the widget. It has the same general form as all frame and
#    label widgets have.
#
#    The following actions are supported:
#      cget
#      configure
#
#    See the "frame" and "label" manuals for details on the standard
#    widget actions.
#
#  BINDINGS
#     When a new shorthelp is created, it has no default event
#     bindings: shorthelps are not intended to be interactive.
#     When using shorthelp widgets there are some global bindings on
#     all widgets of the application. Entering a widget will display
#     the respective helptext if any. Leaving the widget will end the
#     displaying of the help text.
#
#  EXAMPLES
#      shorthelp .h -width 50
#      .h configure -bg red
#
#  SEE ALSO
#    frame, label
#
#  BUGS
#    If you find some, e-mail me please.
#
#  AUTHOR
#    @(#) Andreas Tusche (mailto:tusche@mpia-hd.mpg.de)
#
#  MODIFICATION HISTORY
#      07.May.97  A.Tusche  shorthelp created
#      18.May.97  A.Tusche  atkShortHelp added
#      20.May.97  A.Tusche  atkShortHelpCmd and option database added
#      23.May.97  A.Tusche  new options frameXXXXXX and labelXXXXXX
#=====================================================================
#  TODO
#  - configure mit einem oder keinem Argument liefert nur Infos ueber
#    das Label. frameXXXXXX und labelXXXXXX werden ueberhaupt nicht
#    zurueckgegeben.
#  - default font bestimmen (atkFontManager?)

if ![info exists tkPriv(atk)] atkInit

#=====================================================================
# Option Database for shorthelp
#=====================================================================

# frame and all descendants (options valid for frame)

option add *ShortHelp*background          $tkPriv(colBG)  $tkPriv(atkOptPri)
option add *ShortHelp*borderWidth         2               $tkPriv(atkOptPri)
option add *ShortHelp*colormap            .               $tkPriv(atkOptPri)
option add *ShortHelp*cursor              {}              $tkPriv(atkOptPri)
option add *ShortHelp*foreground          $tkPriv(colFG)  $tkPriv(atkOptPri)
option add *ShortHelp*height              0               $tkPriv(atkOptPri)
option add *ShortHelp*highlightBackground $tkPriv(colHIB) $tkPriv(atkOptPri)
option add *ShortHelp*highlightColor      $tkPriv(colHIC) $tkPriv(atkOptPri)
option add *ShortHelp*highlightThickness  0               $tkPriv(atkOptPri)
option add *ShortHelp*relief              flat            $tkPriv(atkOptPri)
option add *ShortHelp*takeFocus           0               $tkPriv(atkOptPri)
option add *ShortHelp*visual              {}              $tkPriv(atkOptPri)
option add *ShortHelp*width               0               $tkPriv(atkOptPri)

# all descendants (options not valid to frame but to some other)

option add *ShortHelp*anchor              center          $tkPriv(atkOptPri)
option add *ShortHelp*bitmap              {}	          $tkPriv(atkOptPri)
#option add *ShortHelp*font                fixed	   $tkPriv(atkOptPri)
option add *ShortHelp*image               {}	          $tkPriv(atkOptPri)
option add *ShortHelp*justify             center          $tkPriv(atkOptPri)
option add *ShortHelp*padX                1	          $tkPriv(atkOptPri)
option add *ShortHelp*padY                0	          $tkPriv(atkOptPri)
option add *ShortHelp*text                {}	          $tkPriv(atkOptPri)
option add *ShortHelp*textVariable        V(sHelp)        $tkPriv(atkOptPri)
option add *ShortHelp*underline           -1	          $tkPriv(atkOptPri)
option add *ShortHelp*wraplength          0               $tkPriv(atkOptPri)

# special descendants (options that differ from above definitions)

option add *ShortHelp*sHelp.background          $tkPriv(colHLP) $tkPriv(atkOptPri)
option add *ShortHelp*sHelp.highlightBackground $tkPriv(colHLP) $tkPriv(atkOptPri)
option add *ShortHelp*sHelp.padX                1               $tkPriv(atkOptPri)
option add *ShortHelp*sHelp.padY                1               $tkPriv(atkOptPri)
option add *ShortHelp*sHelp.relief              ridge           $tkPriv(atkOptPri)


#=====================================================================
# atkDisplayShortHelp - procedure to display short help
#   w    widget to display help for
#=====================================================================

proc atkDisplayShortHelp {{w none}} {
    global tkPriv
    upvar $tkPriv(shortHelpTextArray) text
    upvar $tkPriv(shortHelpVariable)  var

    if [info exists text($w)] {set var "$text($w)"} else {set var ""}
}

#=====================================================================
# atkShortHelpCmd - Handle widget related commands
#   w        original widget name (before it has been renamed)
#   argList  list of arguments
#=====================================================================

proc atkShortHelpCmd {w argsList} {
    global tkPriv

    set cmd [lindex $argsList 0]
    set arg [lrange $argsList 1 end]
    set newname [atkNewWdgProcName $w]

    switch $cmd {
	cget  {
	    return [lindex [atkShortHelpCmd $w "configure $arg"] 4]
	}

	configure {
	    set nArgs [llength $arg]

	    if {$nArgs == 0} {
		set out [eval $w.sHelp $cmd]
		# help
		global $tkPriv(shortHelpTextArray)
		lappend out "-help help Text {[set $tkPriv(shortHelpTextArray)($w.sHelp)]}"
		# helparray
		lappend out "-helparray helpArray Variable mHELP $tkPriv(shortHelpTextArray)"
		return [lsort $out]
	    }

	    if {$nArgs == 1} {
		set opt [string range $arg 1 end]
		switch [string tolower $opt] {
		    help {
			global $tkPriv(shortHelpTextArray)
			lappend out "-help help Text {[set $tkPriv(shortHelpTextArray)($w.sHelp)]}"
		    }
		    helparray {lappend out "-helparray helpArray Variable mHELP $tkPriv(shortHelpTextArray)"}
		    #_default -
		    default {set out [eval $w.sHelp $cmd $arg]}
		}
		return $out
	    }

	    # The following code only is executed if nArgs > 1
	    set fopts ""
	    set lopts ""
	    set popts ""
	    set repack 0

	    for {set i 0} {$i < $nArgs} {incr i 2} {
		set opt [string range [lindex $arg $i] 1 end]
		set val [lindex $arg [expr $i + 1]]
		if {[string index $val 0] == "-"} {
		    error "value for \"$opt\" missing"
		}
		switch [string tolower $opt] {
		    #_frame_options -
		    colormap -
		    visual {append fopts "-$opt $val "}
		    framebackground -
		    frameborderwidth -
		    framecursor -
		    frameforeground -
		    frameheight -
		    framehighlightbackground -
		    framehighlightcolor -
		    framehighlightthickness -
		    framerelief -
		    framewidth {
			append fopts "-[string range $opt 5 end] $val "
		    }
		    #_frame_and_label_options -
		    cursor -
		    highlightbackground -
		    highlightcolor -
		    highlightthickness -
		    takefocus {
			append fopts "-$opt $val "
			append lopts "-$opt $val "
		    }
		    #_label_options -
		    anchor -
		    background -
		    bd -
		    bg -
		    borderwidth -
		    fg -
		    font -
		    foreground -
		    height -
		    justify -
		    relief -
		    textvariable -
		    underline -
		    width -
		    wrapLength {append lopts "-$opt $val "}
		    ipadx {append lopts "-padx $val "}
		    ipady {append lopts "-pady $val "}
		    labelbackground -
		    labelborderwidth -
		    labelcursor -
		    labelforeground -
		    labelheight -
		    labelhighlightbackground -
		    labelhighlightcolor -
		    labelhighlightthickness -
		    labelrelief -
		    labelwidth {
			append lopts "-[string range $opt 5 end] $val "
		    }
		    #_special -
		    help {
			global $tkPriv(shortHelpTextArray)
			set $tkPriv(shortHelpTextArray)($w.sHelp) $val
		    }
		    helparray {set tkPriv(shortHelpTextArray) $val}
		    padx -
		    pady {
			append popts "-$opt $val "
			set repack true
		    }
		    #_default -
		    default {error "Unknown or wrong option $opt"}
		}
	    }
	    eval $w.sHelp $cmd $lopts
	    eval $newname $cmd $fopts
	    if {$repack} {eval pack $cmd $w.sHelp $popts}
	}

	default {return -code error -errorinfo "Unknown command to ${w}: $cmd"}
    }
    return
}


#=====================================================================
#
#=====================================================================

proc shorthelp {w args} {
    global tkPriv

    # highlander mode: there can only be one
    if [info exists tkPriv(shortHelpTextArray)] {
	return -code error -errorinfo "only one shorthelp widget is allowed"
    }

    # set some defaults, may be overwritten by options
    set myHelpText "I'm proud to be a short help text"
    set tkPriv(shortHelpTextArray) sHELP

    # create two widgets and pack them
    eval frame $w -class ShortHelp
    eval label $w.sHelp
    pack $w.sHelp -fill both -in $w

    # change widget related procedure <-- this is the main trick!
    set newname [atkNewWdgProcName $w]
    rename $w $newname
    eval proc $w \{args\} \{atkShortHelpCmd ${w} \$args \}

    # and now configure the widgets
    atkShortHelpCmd $w "configure $args"

    # remember textvariable and own helptext
    set tkPriv(shortHelpVariable) [$w.sHelp cget -textvariable]
    upvar $tkPriv(shortHelpTextArray) text
    set text($w.sHelp) $myHelpText

    #-----------------------------------------------------------------
    # bindings
    #-----------------------------------------------------------------
    bind all <Enter> {+ atkDisplayShortHelp %W}
    bind all <Leave> {+ atkDisplayShortHelp}

    return $w
}

#
#     _/_/_/_/        _/_/_/_/_/
#    _/    _/            _/
#   _/_/_/_/  _/_/_/_/  _/  _/    _/
#  _/    _/  _/    _/  _/  _/    _/
# _/    _/  _/    _/  _/  _/_/_/_/
