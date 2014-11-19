#############################################################-*-tcl-*-
# NAME
#   atkMenu
#
# SYNOPSIS
#   atkMenu pathName list
#
# DESCRIPTION
#     pathName  is the pathName of the menubar frame
#     list      is a list containing the menu description
#       {MB1 {MC11 ?MC12? ...} ?MB2 {MC21 ?MC22? ...}? ...}
#       MBn   is the name of the menubutton
#       MCnm  are the menu entries
#       if MCnm starts with "c_" it is treated as a checkbutton
#       if MCnm starts with "r_" it is treated as a radiobutton
#       if MCnm is a list it is treated as a cascaded menu
#       in all other cases MCnm is treated as a command button
#
#  BUGS
#    If you find some, e-mail me please.
#
#  AUTHOR
#    @(#) Andreas Tusche (mailto:tusche@mpia-hd.mpg.de)
#
# MODIFICATION HISTORY
#     31.May.97  A.Tusche  created
#=====================================================================
#  TODO
#  - anzuzeigende Strings sollten Leerzeichen enthalten duerfen
#

proc atkMenu {w list {prefix ""}} {
    global tkPriv

    frame $w
    for {set i 0} {$i < [llength $list]} {incr i 2} {
	set cmd1 [lindex $list $i]
	set list2 [lindex $list [expr $i + 1]]

	# ------------------------------------------------------------
	# menu bar buttons
	# ------------------------------------------------------------
	menubutton $w.m$cmd1 -menu $w.m$cmd1.m -relief flat -text $cmd1
	menu $w.m$cmd1.m

	foreach l2 $list2 {
	    if {[llength $l2] > 1} {
		# ----------------------------------------------------
		# have a cascaded menu
		# ----------------------------------------------------
		set cmd2 [lindex $l2 0]
		set list3 [lindex $l2 1]
		$w.m$cmd1.m add cascade -label $cmd2 -menu $w.m$cmd1.m.m$cmd2
		menu $w.m$cmd1.m.m$cmd2

		foreach l3 $list3 {
		    set cmd3 $l3
		    puts "cmd = ${prefix}${cmd1}${cmd2}${cmd3}"
		    switch [string range $cmd3 0 1] {
			# -
			#_checkbutton -
			"c_" {
			    set cmd3 [string range $cmd3 2 end]
			    $w.m$cmd1.m.m$cmd2 add checkbutton -label $cmd3 -variable tkPriv(atk$cmd3) -command ${prefix}${cmd1}${cmd2}${cmd3}
			}
			# -
			#_radiobutton -
			"r_" {
			    set cmd3 [string range $cmd3 2 end]
			    $w.m$cmd1.m.m$cmd2 add radiobutton -label $cmd3 -value $cmd3 -variable tkPriv(atk$cmd2) -command ${prefix}${cmd1}${cmd2}${cmd3}
			}
			# -
			#_command -
			default {
			    $w.m$cmd1.m.m$cmd2 add command -label $cmd3 -command ${prefix}${cmd1}${cmd2}${cmd3}
			}
		    }
		}

	    } else {
		# ----------------------------------------------------
		# have NO cascaded menu
		# ----------------------------------------------------
		set cmd2 $l2
		puts "cmd = ${prefix}${cmd1}${cmd2}"
		switch [string range $cmd2 0 1] {
		    # -
		    #_checkbutton -
		    "c_" {
			set cmd2 [string range $cmd2 2 end]
			$w.m$cmd1.m add checkbutton -label $cmd2 -variable tkPriv(atk$cmd2) -command ${prefix}${cmd1}${cmd2}
		    }
		    # -
		    #_radiobutton -
		    "r_" {
			set cmd2 [string range $cmd2 2 end]
			$w.m$cmd1.m add radiobutton -label $cmd2 -value $cmd2 -variable tkPriv(atk$cmd1) -command ${prefix}${cmd1}${cmd2}
		    }
		    # -
		    #_command -
		    default {
			$w.m$cmd1.m add command -label $cmd2 -command ${prefix}${cmd1}${cmd2}
		    }
		}
	    }
	}
	pack $w.m$cmd1 -side left
    }
}

#
#     _/_/_/_/        _/_/_/_/_/
#    _/    _/            _/
#   _/_/_/_/  _/_/_/_/  _/  _/    _/
#  _/    _/  _/    _/  _/  _/    _/
# _/    _/  _/    _/  _/  _/_/_/_/

