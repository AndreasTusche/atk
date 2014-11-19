#############################################################-*-tcl-*-
#  NAME
#    atkInit - initialize Andreas' Tool Kit
#
#  DESCRIPTION
#    procedures defined herein:
#      atkNewWdgProcName - new name for widget related function
#      atkColorScheme    - sets color scheme
#      atkInit           - initialize atk
#      atkLookAndFeel    - sets widget look and feel scheme
#      atkOptions        - extract new widget options
#      button            - same as old Tk's widget plus some new options
#      canvas            - same as old Tk's widget plus some new options
#      checkbutton       - same as old Tk's widget plus some new options
#      entry             - same as old Tk's widget plus some new options
#      label             - same as old Tk's widget plus some new options
#      listbox           - same as old Tk's widget plus some new options
#      menu              - same as old Tk's widget plus some new options
#      menubutton        - same as old Tk's widget plus some new options
#      message           - same as old Tk's widget plus some new options
#      radiobutton       - same as old Tk's widget plus some new options
#      scale             - same as old Tk's widget plus some new options
#      scrollbar         - same as old Tk's widget plus some new options
#      text              - same as old Tk's widget plus some new options
#      tkButton          - Tk's original definition of this widget
#      tkCanvas          - Tk's original definition of this widget
#      tkCheckbutton     - Tk's original definition of this widget
#      tkEntry           - Tk's original definition of this widget
#      tkLabel           - Tk's original definition of this widget
#      tkListbox         - Tk's original definition of this widget
#      tkMenu            - Tk's original definition of this widget
#      tkMenubutton      - Tk's original definition of this widget
#      tkMessage         - Tk's original definition of this widget
#      tkRadiobutton     - Tk's original definition of this widget
#      tkScale           - Tk's original definition of this widget
#      tkScrollbar       - Tk's original definition of this widget
#      tkText            - Tk's original definition of this widget
#
#  MODIFICATION HISTORY
#      09.May.97  A.Tusche  new widget command definitions
#      18.May.97  A.Tusche  atkNewWdgProcName
#      20.May.97  A.Tusche  atkColorScheme, atkLookAndFeel added
#=====================================================================
#  TODO
#  -
#

#=====================================================================
# atkInit - initialize atk, sets default option database
#=====================================================================

proc atkInit {} {
    global auto_path tkPriv

    #-----------------------------------------------------------------
    # run this only once
    #-----------------------------------------------------------------
    if [info exists tkPriv(atk)] return
    set tkPriv(atk) true

    #-----------------------------------------------------------------
    # make sure to have path to this library in first place
    #-----------------------------------------------------------------
    if ![file exists "[lindex $auto_path 0]/atkInit.tcl"] {
	error "Make sure to have atk's directory in first place of auto_path"
    }

    #-----------------------------------------------------------------
    # rename constructors for Tk's standard widgets
    #-----------------------------------------------------------------
    rename button tkButton
    rename canvas tkCanvas
    rename checkbutton tkCheckbutton
    rename entry tkEntry
    rename label tkLabel
    rename listbox tkListbox
    rename menu tkMenu
    rename menubutton tkMenubutton
    rename message tkMessage
    rename radiobutton tkRadiobutton
    rename scale tkScale
    rename scrollbar tkScrollbar
    rename text tkText

    #-----------------------------------------------------------------
    # misc
    #-----------------------------------------------------------------
    set tkPriv(atkOptPri) 60
    atkColorScheme set standard
    atkLookAndFeel set standard

    return
}
# run this procedure immediately
atkInit


#=====================================================================
# atkColorScheme - set color scheme
# cmd     one out of {get set}
# scheme  one out of {standard}
#=====================================================================

proc atkColorScheme {cmd {scheme ""}} {
    global tkPriv

    # get scheme
    if {"$cmd" == "get" && "$scheme" == ""} {
	if [info exists $tkPriv(colScheme)] {
	    set scheme $tkPriv(colScheme)
	} else {
	    set scheme standard
	}
    }

    # define scheme
    switch $scheme {
	standard {
	    set tkPriv(colScheme) standard
	    set tkPriv(colABG) Gray80         ;# active background
	    set tkPriv(colAFG) Black          ;# active foreground
	    set tkPriv(colBG)  Gray90         ;# background
	    set tkPriv(colDIS) Gray60         ;# disabled
	    set tkPriv(colEBG) MistyRose      ;# entry background
	    set tkPriv(colERR) Red            ;# Error message
	    set tkPriv(colFG)  Black          ;# foreground (=text)
	    set tkPriv(colHIB) Gray90         ;# framecolor for unselected widget
	    set tkPriv(colHIC) Red            ;# framecolor for selected widget
	    set tkPriv(colHLP) LightYellow1   ;# help background
	    set tkPriv(colIBG) Red            ;# insert background
	    set tkPriv(colMEN) LightSteelBlue ;# active Menu
	    set tkPriv(colMSG) Yellow         ;# Warning message
	    set tkPriv(colSBG) RosyBrown      ;# selection background
	    set tkPriv(colSFG) Black          ;# selection foreground
	    set tkPriv(colSEL) Green          ;# selector indicator
	}
	default {error "wrong color scheme $scheme"}
    }

    # activate scheme
    if {"$cmd" == "set"} {
	option add *activeBackground    $tkPriv(colABG) $tkPriv(atkOptPri)
	option add *activeForeground    $tkPriv(colAFG) $tkPriv(atkOptPri)
	option add *background	      	$tkPriv(colBG)  $tkPriv(atkOptPri)
	option add *disabledForeground  $tkPriv(colDIS) $tkPriv(atkOptPri)
	option add *foreground	      	$tkPriv(colFG)  $tkPriv(atkOptPri)
	option add *highlightBackground $tkPriv(colHIB)	$tkPriv(atkOptPri)
	option add *highlightColor	$tkPriv(colHIC) $tkPriv(atkOptPri)
	option add *insertBackground    $tkPriv(colIBG) $tkPriv(atkOptPri)
	option add *selectBackground    $tkPriv(colSBG) $tkPriv(atkOptPri)
	option add *selectColor         $tkPriv(colSEL) $tkPriv(atkOptPri)
	option add *selectForeground    $tkPriv(colSFG) $tkPriv(atkOptPri)
	option add *troughColor         $tkPriv(colDIS) $tkPriv(atkOptPri)

	option add *Entry*background             $tkPriv(colEBG) $tkPriv(atkOptPri)
	option add *Menu*activeBackground        $tkPriv(colMEN) $tkPriv(atkOptPri)
	option add *Menubutton*activeBackground  $tkPriv(colMEN) $tkPriv(atkOptPri)
    }

    return $scheme
}

#=====================================================================
# atkLookAndFeel - set look and feel scheme
# cmd     one out of {get set}
# scheme  one out of {flat standard}
#=====================================================================

proc atkLookAndFeel {cmd {scheme ""}} {
    global tkPriv

    # get scheme
    if {"$cmd" == "get" && "$scheme" == ""} {
	if [info exists $tkPriv(lafScheme)] {
	    set scheme $tkPriv(lafScheme)
	} else {
	    set scheme standard
	}
    }

    # define and activate scheme
    if {"$cmd" == "set"} {
	switch $scheme {
	    flat {
		set tkPriv(lafScheme) flat
		option add *activeBorderWidth  0    $tkPriv(atkOptPri)
		option add *anchor             w    $tkPriv(atkOptPri)
		option add *avtiveRelief       0    $tkPriv(atkOptPri)
		option add *borderWidth        0    $tkPriv(atkOptPri)
		option add *elementBorderWidth 0    $tkPriv(atkOptPri)
		option add *height             0    $tkPriv(atkOptPri)
		option add *highlightThickness 0    $tkPriv(atkOptPri)
		option add *indicatorOn        true $tkPriv(atkOptPri)
		option add *insertBorderWidth  0    $tkPriv(atkOptPri)
		option add *padX               0    $tkPriv(atkOptPri)
		option add *padY               0    $tkPriv(atkOptPri)
		option add *relief             flat $tkPriv(atkOptPri)
		option add *selectBorderWidth  0    $tkPriv(atkOptPri)
		option add *width              0    $tkPriv(atkOptPri)
	    }
	    standard {
		set tkPriv(lafScheme) standard
		option add *activeBorderWidth  0    $tkPriv(atkOptPri)
		option add *anchor             w    $tkPriv(atkOptPri)
		option add *borderWidth        2    $tkPriv(atkOptPri)
		option add *highlightThickness 0    $tkPriv(atkOptPri)
		option add *insertWidth        2    $tkPriv(atkOptPri)
		option add *padX               0    $tkPriv(atkOptPri)
		option add *padY               0    $tkPriv(atkOptPri)
		option add *relief             flat $tkPriv(atkOptPri)
                #
		option add *Button*anchor      center $tkPriv(atkOptPri)
		option add *Button*relief      raised $tkPriv(atkOptPri)
		option add *Button*padX        3m     $tkPriv(atkOptPri)
		option add *Button*padY        1m     $tkPriv(atkOptPri)
		option add *Checkbutton*relief raised $tkPriv(atkOptPri)
		option add *Checkbutton*padX   1      $tkPriv(atkOptPri)
		option add *Checkbutton*padY   1      $tkPriv(atkOptPri)
		option add *Entry*relief       sunken $tkPriv(atkOptPri)
		option add *Label*anchor       w      $tkPriv(atkOptPri)
		option add *Label*borderWidth  0      $tkPriv(atkOptPri)
		option add *Listbox*relief     sunken $tkPriv(atkOptPri)
		option add *Menu*relief        raised $tkPriv(atkOptPri)
		option add *Menubutton*relief  raised $tkPriv(atkOptPri)
		option add *Menubutton*padX    1      $tkPriv(atkOptPri)
		option add *Menubutton*padY    1      $tkPriv(atkOptPri)
		option add *Radiobutton*padX   1      $tkPriv(atkOptPri)
		option add *Radiobutton*padY   1      $tkPriv(atkOptPri)
		option add *Text*wrap          word   $tkPriv(atkOptPri)
	    }
	    default {error "wrong scheme $scheme"}
	}
    }

    return $scheme
}


#=====================================================================
# atkNewWdgProcName  -  create new name for widget related procedure
#=====================================================================
proc atkNewWdgProcName {w} {
    return "[file rootname $w].atk_[string range [file extension $w] 1 end]"
}


#=====================================================================
# atkOptions - parse new options of Tk's standard widgets
#=====================================================================

proc atkOptions {w varName} {
    global tkPriv
    catch {global $tkPriv(shortHelpTextArray)}
    catch {global $tkPriv(miniHelpTextArray)}

    upvar $varName argList

    # -help
    if {[set pos [lsearch $argList "-help"]] != -1} {
	set npos [expr $pos + 1]
	set val [lindex  $argList $npos]
	if [catch {set  $tkPriv(shortHelpTextArray)($w) $val}] {
	    return -code error -errorinfo "help option without shorthelp widget"
	}
	set argList [lreplace $argList $pos $npos]
    }

    # -minihelp
    if {[set pos [lsearch $argList "-minihelp"]] != -1} {
	set npos [expr $pos + 1]
	set val [lindex  $argList $npos]
	if [catch {set  $tkPriv(miniHelpTextArray)($w) $val}] {
	    return -code error -errorinfo "minihelp option without minihelp widget"
	}
	set argList [lreplace $argList $pos $npos]
    }
}


#=====================================================================
# new procedures for constructors of Tk's standard widgets
#=====================================================================
proc button {w args} {
    atkOptions $w args
    uplevel tkButton $w $args
}

proc canvas {w args} {
    atkOptions $w args
    uplevel tkCanvas $w $args
}

proc checkbutton {w args} {
    atkOptions $w args
    uplevel tkCheckbutton $w $args
}

proc entry {w args} {
    atkOptions $w args
    uplevel tkEntry $w $args
}

proc label {w args} {
    atkOptions $w args
    uplevel tkLabel $w $args
}

proc listbox {w args} {
    atkOptions $w args
    uplevel tkListbox $w $args
}

proc menu {w args} {
    atkOptions $w args
    uplevel tkMenu $w $args
}

proc menubutton {w args} {
    atkOptions $w args
    uplevel tkMenubutton $w $args
}

proc message {w args} {
    atkOptions $w args
    uplevel tkMessage $w $args
}

proc radiobutton {w args} {
    atkOptions $w args
    uplevel tkRadiobutton $w $args
}

proc scale {w args} {
    atkOptions $w args
    uplevel tkScale $w $args
}

proc scrollbar {w args} {
    atkOptions $w args
    uplevel tkScrollbar $w $args
}

proc text {w args} {
    atkOptions $w args
    uplevel tkText $w $args
}


#
#     _/_/_/_/        _/_/_/_/_/
#    _/    _/            _/
#   _/_/_/_/  _/_/_/_/  _/  _/    _/
#  _/    _/  _/    _/  _/  _/    _/
# _/    _/  _/    _/  _/  _/_/_/_/



