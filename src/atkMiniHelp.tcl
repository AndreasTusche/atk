#############################################################-*-tcl-*-
#  NAME
#    minihelp - Create and manipulate mini help widgets
#
#  SYNOPSIS
#    minihelp pathName ?options?
#
#  DESCRIPTION
#    The minihelp command creates two new windows
#      pathName        a toplevel widget
#      pathName.mHelp  a label widget
#
#    Additional options, described below, may be specified on the
#    command line or in the option database to configure aspects of
#    the minihelp. The minihelp command returns its pathName
#    argument.  At the time this command is invoked, there must not
#    exist a window named pathName, but pathName's parent must exist.
#
#    A minihelp is a widget that displays a textual string describing
#    another widget of the same application. The text to display is
#    given by the "-minihelp" option of the OTHER widget. If text is
#    displayed, it must all be in a single font, but it can occupy
#    multiple lines on the screen (if it contains newlines or if
#    wrapping occurs because of the wrapLength option) and one of the
#    characters may optionally be underlined using the underline
#    option.  The minihelp can be manipulated in a few simple ways,
#    using the commands described below.
#
#    Actually the text to display is taken from a global array. The
#    Name of the array defaults to mHELP but may be changed with the
#    helparray option. The elements of the array have to be the
#    pathNames of the other widgets in the application.
#
#  STANDARD OPTIONS
#    All standard options of toplevel and label widgets resp. may be
#    used: anchor background bitmap borderWidth cursor font foreground
#    highlightBackground highlightColor highlightThickness image
#    justify padX padY relief takeFocus text textVariable underline
#    wrapLength
#
#    See the "label" and "toplevel" manuals for details on the standard
#    options.
#
#  WIDGET-SPECIFIC OPTIONS
#      Name:                delay
#      Class:               -
#      Command-Line Switch: -delay
#    Specifies the delay in ms (milliseconds) for mini help text to
#    appear after entering a widget. Defaults to 1000 (= 1 sec). The
#    delay option may not be changed with the configure widget
#    command.
#
#      Name:                helparray
#      Class:               -
#      Command-Line Switch: -helparray
#    Specifies the name of a global array containing the help texts of
#    widgets. The Name of the array defaults to mHELP but may be
#    changed with the helparray option. The elements of the array have
#    to be the pathNames of the other widgets in the application. The
#    helparray option may not be changed with the configure widget
#    command.
#
#  WIDGET COMMAND
#    The minihelp command creates two new Tcl commands whose names
#    are pathName and pathName.mHelp.  These commands may be used to
#    invoke various operations on the widgets. It has the same general
#    form as all label and toplevel widgets have.
#
#    See the "label" and "toplevel" manuals for details on the standard
#    widget commands.
#
#  BINDINGS
#     When a new minihelp is created, it has no default event
#     bindings: minihelps are not intended to be interactive.  When
#     using minihelp widgets there are some global bindings on all
#     widgets of the application. Entering a widget will display the
#     respective helptext after a delay of one second if the
#     mousecurser still is in the same widget. Leaving the widget will
#     end the displaying of the help text.
#
#  EXAMPLES
#       minihelp .m -background red -delay 500
#
#  SEE ALSO
#    label toplevel
#
#  BUGS
#    Highlander mode: There can only be one
#
#  AUTHOR
#    @(#) Andreas Tusche (tusche@mpia-hd.mpg.de)
#
#  MODIFICATION HISTORY
#      10.May.97  A.Tusche  minihelp created
#      20.May.97  A.Tusche  atkMiniHelpCmd, option database added
#=====================================================================
#  TODO
#  - optionen den subwidgets zuweisen

if ![info exists tkPriv(atk)] atkInit

#=====================================================================
# Option Database for minihelp
#=====================================================================

# toplevel and all descendants (options valid for toplevel)

option add *MiniHelp*background          $tkPriv(colFG)  $tkPriv(atkOptPri)
option add *MiniHelp*colormap            .               $tkPriv(atkOptPri)
option add *MiniHelp*cursor              {}              $tkPriv(atkOptPri)
option add *MiniHelp*height              0               $tkPriv(atkOptPri)
option add *MiniHelp*highlightBackground $tkPriv(colHIB) $tkPriv(atkOptPri)
option add *MiniHelp*highlightColor      $tkPriv(colHIC) $tkPriv(atkOptPri)
option add *MiniHelp*highlightThickness  0               $tkPriv(atkOptPri)
option add *MiniHelp*relief              flat            $tkPriv(atkOptPri)
option add *MiniHelp*takeFocus           0               $tkPriv(atkOptPri)
option add *MiniHelp*visual              {}              $tkPriv(atkOptPri)
option add *MiniHelp*width               0               $tkPriv(atkOptPri)

# all descendants (options not valid to toplevel but to some other)

option add *MiniHelp*anchor              center          $tkPriv(atkOptPri)
option add *MiniHelp*bitmap              {}	         $tkPriv(atkOptPri)
option add *MiniHelp*borderWidth         1               $tkPriv(atkOptPri)
#option add *MiniHelp*font                fixed	          $tkPriv(atkOptPri)
option add *MiniHelp*foreground          $tkPriv(colFG)  $tkPriv(atkOptPri)
option add *MiniHelp*image               {}	         $tkPriv(atkOptPri)
option add *MiniHelp*justify             center          $tkPriv(atkOptPri)
option add *MiniHelp*padX                1	         $tkPriv(atkOptPri)
option add *MiniHelp*padY                1	         $tkPriv(atkOptPri)
option add *MiniHelp*text                {}	         $tkPriv(atkOptPri)
option add *MiniHelp*textVariable        V(mHelp)        $tkPriv(atkOptPri)
option add *MiniHelp*underline           -1	         $tkPriv(atkOptPri)
option add *MiniHelp*wraplength          0               $tkPriv(atkOptPri)

# special descendants (options that differ from above definitions)

option add *MiniHelp*mHelp.background          $tkPriv(colHLP) $tkPriv(atkOptPri)
option add *MiniHelp*mHelp.highlightBackground $tkPriv(colHLP) $tkPriv(atkOptPri)


#---------------------------------------------------------------------
# atkDisplayMiniHelp - procedure to display mini help
#   wMH  pathname of the minihelp widget
#   x    cursor x position
#   y    cursor y position
#   w    widget to display help for
#---------------------------------------------------------------------

proc atkDisplayMiniHelp {wMH {x 0} {y 0} {w none}} {
    if {$w == "none"} {
	wm withdraw $wMH
	return
    }

    # check if we are still in the same widget
    if {[winfo containing [winfo pointerx .] [winfo pointery .]] != $w} return

    global tkPriv
    upvar $tkPriv(miniHelpTextArray) text
    upvar $tkPriv(miniHelpVariable)  var

    # if there is a mini help text defined, display it
    if [info exists text($w)] {
	set var "$text($w)"
	wm geometry $wMH "+${x}+[expr [winfo rooty $w] + [winfo height $w]]"
	wm deiconify $wMH
	raise $wMH
    } else {
	wm withdraw $wMH
	set var ""
    }
}


#=====================================================================
# atkMiniHelpCmd - Handle widget related commands
#   w        original widget name (before it has been renamed)
#   argList  list of arguments
#=====================================================================

proc atkMiniHelpCmd {w argsList} {
    global tkPriv

    set cmd [lindex $argsList 0]
    set arg [lrange $argsList 1 end]
    set newname [atkNewWdgProcName $w]

    switch $cmd {
	configure {
	    set nArgs [llength $arg]

	    if {$nArgs == 0} {
		set out [eval $w.mHelp $cmd]
		# helparray
		lappend out "-helparray helpArray Variable mHELP $tkPriv(miniHelpTextArray)"
		return [lsort $out]
	    }

	    if {$nArgs == 1} {
		set opt [string range $arg 1 end]
		switch [string tolower $opt] {
		    helparray {lappend out "-helparray helpArray Variable mHELP $tkPriv(miniHelpTextArray)"}
		    default {set out [eval $w.mHelp $cmd $arg]}
		}
		return $out
	    }

	    # The following code is executed only if nArgs > 1
	    set topts ""
	    set lopts ""
	    for {set i 0} {$i < $nArgs} {incr i 2} {
		set opt [string range [lindex $arg $i] 1 end]
		set val [lindex $arg [expr $i + 1]]
		if {[string index $val 0] == "-"} {
		    error "value for \"$opt\" missing"
		}
		switch [string tolower $opt] {
		    #_toplevel_options -
		    borderwidth -
		    class -
		    colormap -
		    visual {append topts "-$opt $val "}
		    #_toplevel_and_label_options -
		    cursor -
		    highlightbackground -
		    highlightcolor -
		    highlightthickness -
		    height -
		    relief -
		    takefocus -
		    width {
			append topts "-$opt $val "
			append lopts "-$opt $val "
		    }
		    #_label_options -
		    anchor -
		    background -
		    bd -
		    bg -
		    bitmap -
		    fg -
		    font -
		    foreground -
		    image -
		    justify -
		    padx -
		    pady -
		    text -
		    textvariable -
		    underline -
		    wrapLength {append lopts "-$opt $val "}
		    #_special -
		    delay {set tkPriv(miniHelpDelay) $val}
		    helparray {set tkPriv(miniHelpTextArray) $val}
		    #_default -
		    default {error "Unknown or wrong option $opt"}
		}
	    }
	    eval $newname $cmd $topts
	    eval $w.mHelp $cmd $lopts
	}
	cget           -
	default {error "Unknown command to ${w}: $cmd"}
    }
    return
}

#=====================================================================
# minihelp
#=====================================================================

proc minihelp {{w .mHelp} args} {
    global tkPriv

    # highlander mode: there can only be one
    if [info exists tkPriv(miniHelpTextArray)] {
	return -code error -errorinfo "only one minihelp widget is allowed"
    }

    # set some defaults, may be overwiritten by options
    set tkPriv(miniHelpDelay) 1000
    set tkPriv(miniHelpTextArray) mHELP
    if {[string index $w 0] == "-"} {
	set args "$w $args"
	set w .mHelp
    }

    # create widget and hide it
    eval toplevel $w -class MiniHelp
    eval label $w.mHelp
    wm overrideredirect $w true
    wm withdraw $w
    pack $w.mHelp
    raise $w .

    # change widget related procedure <-- this is the main trick!
    set newname [atkNewWdgProcName $w]
    rename $w $newname
    eval proc $w \{args\} \{atkMiniHelpCmd ${w} \$args \}

    # and now configure the widgets
    atkMiniHelpCmd $w "configure $args"

    # remember textvariable
    set tkPriv(miniHelpVariable) [$w.mHelp cget -textvariable]

    #-----------------------------------------------------------------
    # bindings
    #-----------------------------------------------------------------
    eval bind all <Enter> \{+ set tkPriv(miniHelpAfterId) \[after \$tkPriv(miniHelpDelay) atkDisplayMiniHelp $w %X %Y %W\]\}
    eval bind all <Leave> \{+ after cancel \$tkPriv(miniHelpAfterId) \;  atkDisplayMiniHelp $w\}

    return $w
}

#
#     _/_/_/_/        _/_/_/_/_/
#    _/    _/            _/
#   _/_/_/_/  _/_/_/_/  _/  _/    _/
#  _/    _/  _/    _/  _/  _/    _/
# _/    _/  _/    _/  _/  _/_/_/_/



