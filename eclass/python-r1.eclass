# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

# @ECLASS: python-r1
# @MAINTAINER:
# Python team <python@gentoo.org>
# @AUTHOR:
# Author: Michał Górny <mgorny@gentoo.org>
# Based on work of: Krzysztof Pawlik <nelchael@gentoo.org>
# @BLURB: A common, simple eclass for Python packages.
# @DESCRIPTION:
# A common eclass providing helper functions to build and install
# packages supporting being installed for multiple Python
# implementations.
#
# This eclass sets correct IUSE and REQUIRED_USE. It exports PYTHON_DEPS
# and PYTHON_USEDEP so you can create correct dependencies for your
# package easily. It also provides methods to easily run a command for
# each enabled Python implementation and duplicate the sources for them.
#
# Please note that python-r1 will always inherit python-utils-r1 as
# well. Thus, all the functions defined there can be used
# in the packages using python-r1, and there is no need ever to inherit
# both.
#
# For more information, please see the python-r1 Developer's Guide:
# http://www.gentoo.org/proj/en/Python/python-r1/dev-guide.xml

case "${EAPI:-0}" in
	0|1|2|3)
		die "Unsupported EAPI=${EAPI:-0} (too old) for ${ECLASS}"
		;;
	4|5)
		# EAPI=4 is required for USE default deps on USE_EXPAND flags
		;;
	*)
		die "Unsupported EAPI=${EAPI} (unknown) for ${ECLASS}"
		;;
esac

if [[ ! ${_PYTHON_R1} ]]; then

if [[ ${_PYTHON_SINGLE_R1} ]]; then
	die 'python-r1.eclass can not be used with python-single-r1.eclass.'
elif [[ ${_PYTHON_ANY_R1} ]]; then
	die 'python-r1.eclass can not be used with python-any-r1.eclass.'
fi

inherit multibuild python-utils-r1

# @ECLASS-VARIABLE: PYTHON_COMPAT
# @REQUIRED
# @DESCRIPTION:
# This variable contains a list of Python implementations the package
# supports. It must be set before the `inherit' call. It has to be
# an array.
#
# Example:
# @CODE
# PYTHON_COMPAT=( python2_5 python2_6 python2_7 )
# @CODE
#
# Please note that you can also use bash brace expansion if you like:
# @CODE
# PYTHON_COMPAT=( python{2_5,2_6,2_7} )
# @CODE
if ! declare -p PYTHON_COMPAT &>/dev/null; then
	die 'PYTHON_COMPAT not declared.'
fi

# @ECLASS-VARIABLE: PYTHON_COMPAT_OVERRIDE
# @INTERNAL
# @DESCRIPTION:
# This variable can be used when working with ebuilds to override
# the in-ebuild PYTHON_COMPAT. It is a string listing all
# the implementations which package will be built for. It need be
# specified in the calling environment, and not in ebuilds.
#
# It should be noted that in order to preserve metadata immutability,
# PYTHON_COMPAT_OVERRIDE does not affect IUSE nor dependencies.
# The state of PYTHON_TARGETS is ignored, and all the implementations
# in PYTHON_COMPAT_OVERRIDE are built. Dependencies need to be satisfied
# manually.
#
# Example:
# @CODE
# PYTHON_COMPAT_OVERRIDE='pypy python3_3' emerge -1v dev-python/foo
# @CODE

# @ECLASS-VARIABLE: PYTHON_REQ_USE
# @DEFAULT_UNSET
# @DESCRIPTION:
# The list of USEflags required to be enabled on the chosen Python
# implementations, formed as a USE-dependency string. It should be valid
# for all implementations in PYTHON_COMPAT, so it may be necessary to
# use USE defaults.
#
# This should be set before calling `inherit'.
#
# Example:
# @CODE
# PYTHON_REQ_USE="gdbm,ncurses(-)?"
# @CODE
#
# It will cause the Python dependencies to look like:
# @CODE
# python_targets_pythonX_Y? ( dev-lang/python:X.Y[gdbm,ncurses(-)?] )
# @CODE

# @ECLASS-VARIABLE: PYTHON_DEPS
# @DESCRIPTION:
# This is an eclass-generated Python dependency string for all
# implementations listed in PYTHON_COMPAT.
#
# Example use:
# @CODE
# RDEPEND="${PYTHON_DEPS}
#	dev-foo/mydep"
# DEPEND="${RDEPEND}"
# @CODE
#
# Example value:
# @CODE
# dev-lang/python-exec:=
# python_targets_python2_6? ( dev-lang/python:2.6[gdbm] )
# python_targets_python2_7? ( dev-lang/python:2.7[gdbm] )
# @CODE

# @ECLASS-VARIABLE: PYTHON_USEDEP
# @DESCRIPTION:
# This is an eclass-generated USE-dependency string which can be used to
# depend on another Python package being built for the same Python
# implementations.
#
# The generate USE-flag list is compatible with packages using python-r1
# and python-distutils-ng eclasses. It must not be used on packages
# using python.eclass.
#
# Example use:
# @CODE
# RDEPEND="dev-python/foo[${PYTHON_USEDEP}]"
# @CODE
#
# Example value:
# @CODE
# python_targets_python2_6(-)?,python_targets_python2_7(-)?
# @CODE

# @ECLASS-VARIABLE: PYTHON_REQUIRED_USE
# @DESCRIPTION:
# This is an eclass-generated required-use expression which ensures at
# least one Python implementation has been enabled.
#
# This expression should be utilized in an ebuild by including it in
# REQUIRED_USE, optionally behind a use flag.
#
# Example use:
# @CODE
# REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"
# @CODE
#
# Example value:
# @CODE
# || ( python_targets_python2_6 python_targets_python2_7 )
# @CODE

_python_set_globals() {
	local impls=()

	PYTHON_DEPS=
	local i PYTHON_PKG_DEP
	for i in "${PYTHON_COMPAT[@]}"; do
		_python_impl_supported "${i}" || continue

		python_export "${i}" PYTHON_PKG_DEP
		PYTHON_DEPS+="python_targets_${i}? ( ${PYTHON_PKG_DEP} ) "

		impls+=( "${i}" )
	done

	if [[ ${#impls[@]} -eq 0 ]]; then
		die "No supported implementation in PYTHON_COMPAT."
	fi

	local flags=( "${impls[@]/#/python_targets_}" )
	local optflags=${flags[@]/%/(-)?}

	# A nice QA trick here. Since a python-single-r1 package has to have
	# at least one PYTHON_SINGLE_TARGET enabled (REQUIRED_USE),
	# the following check will always fail on those packages. Therefore,
	# it should prevent developers from mistakenly depending on packages
	# not supporting multiple Python implementations.

	local flags_st=( "${impls[@]/#/-python_single_target_}" )
	optflags+=,${flags_st[@]/%/(-)}

	IUSE=${flags[*]}
	PYTHON_REQUIRED_USE="|| ( ${flags[*]} )"
	PYTHON_USEDEP=${optflags// /,}

	# 1) well, python-exec would suffice as an RDEP
	# but no point in making this overcomplex, BDEP doesn't hurt anyone
	# 2) python-exec should be built with all targets forced anyway
	# but if new targets were added, we may need to force a rebuild
	# 3) use whichever python-exec slot installed in EAPI 5. For EAPI 4,
	# just fix :2 since := deps are not supported.
	if [[ ${_PYTHON_WANT_PYTHON_EXEC2} == 0 ]]; then
		PYTHON_DEPS+="dev-lang/python-exec:0[${PYTHON_USEDEP}]"
	elif [[ ${EAPI} != 4 ]]; then
		PYTHON_DEPS+="dev-lang/python-exec:=[${PYTHON_USEDEP}]"
	else
		PYTHON_DEPS+="dev-lang/python-exec:2[${PYTHON_USEDEP}]"
	fi
}
_python_set_globals

# @ECLASS-VARIABLE: DISTUTILS_JOBS
# @DEFAULT_UNSET
# @DESCRIPTION:
# The number of parallel jobs to run for distutils-r1 parallel builds.
# If unset, the job-count in ${MAKEOPTS} will be used.
#
# This variable is intended to be set in make.conf.

# @FUNCTION: _python_validate_useflags
# @INTERNAL
# @DESCRIPTION:
# Enforce the proper setting of PYTHON_TARGETS.
_python_validate_useflags() {
	debug-print-function ${FUNCNAME} "${@}"

	local i

	for i in "${PYTHON_COMPAT[@]}"; do
		_python_impl_supported "${i}" || continue

		use "python_targets_${i}" && return 0
	done

	eerror "No Python implementation selected for the build. Please add one"
	eerror "of the following values to your PYTHON_TARGETS (in make.conf):"
	eerror
	eerror "${PYTHON_COMPAT[@]}"
	echo
	die "No supported Python implementation in PYTHON_TARGETS."
}

# @FUNCTION: python_gen_usedep
# @USAGE: <pattern> [...]
# @DESCRIPTION:
# Output a USE dependency string for Python implementations which
# are both in PYTHON_COMPAT and match any of the patterns passed
# as parameters to the function.
#
# Remember to escape or quote the patterns to premature evaluation as a file
# name glob.
#
# When all implementations are requested, please use ${PYTHON_USEDEP}
# instead. Please also remember to set an appropriate REQUIRED_USE
# to avoid ineffective USE flags.
#
# Example:
# @CODE
# PYTHON_COMPAT=( python{2_7,3_2} )
# DEPEND="doc? ( dev-python/epydoc[$(python_gen_usedep 'python2*')] )"
# @CODE
#
# It will cause the dependency to look like:
# @CODE
# DEPEND="doc? ( dev-python/epydoc[python_targets_python2_7?] )"
# @CODE
python_gen_usedep() {
	debug-print-function ${FUNCNAME} "${@}"

	local impl pattern
	local matches=()

	for impl in "${PYTHON_COMPAT[@]}"; do
		_python_impl_supported "${impl}" || continue

		for pattern; do
			if [[ ${impl} == ${pattern} ]]; then
				matches+=(
					"python_targets_${impl}(-)?"
					"-python_single_target_${impl}(-)"
				)
				break
			fi
		done
	done

	[[ ${matches[@]} ]] || die "No supported implementations match python_gen_usedep patterns: ${@}"

	local out=${matches[@]}
	echo "${out// /,}"
}

# @FUNCTION: python_gen_useflags
# @USAGE: <pattern> [...]
# @DESCRIPTION:
# Output a list of USE flags for Python implementations which
# are both in PYTHON_COMPAT and match any of the patterns passed
# as parameters to the function.
#
# Example:
# @CODE
# PYTHON_COMPAT=( python{2_7,3_2} )
# REQUIRED_USE="doc? ( || ( $(python_gen_useflags python2*) ) )"
# @CODE
#
# It will cause the variable to look like:
# @CODE
# REQUIRED_USE="doc? ( || ( python_targets_python2_7 ) )"
# @CODE
python_gen_useflags() {
	debug-print-function ${FUNCNAME} "${@}"

	local impl pattern
	local matches=()

	for impl in "${PYTHON_COMPAT[@]}"; do
		_python_impl_supported "${impl}" || continue

		for pattern; do
			if [[ ${impl} == ${pattern} ]]; then
				matches+=( "python_targets_${impl}" )
				break
			fi
		done
	done

	echo "${matches[@]}"
}

# @FUNCTION: python_gen_cond_dep
# @USAGE: <dependency> <pattern> [...]
# @DESCRIPTION:
# Output a list of <dependency>-ies made conditional to USE flags
# of Python implementations which are both in PYTHON_COMPAT and match
# any of the patterns passed as the remaining parameters.
#
# In order to enforce USE constraints on the packages, verbatim
# '${PYTHON_USEDEP}' (quoted!) may be placed in the dependency
# specification. It will get expanded within the function into a proper
# USE dependency string.
#
# Example:
# @CODE
# PYTHON_COMPAT=( python{2_5,2_6,2_7} )
# RDEPEND="$(python_gen_cond_dep \
#   'dev-python/unittest2[${PYTHON_USEDEP}]' python{2_5,2_6})"
# @CODE
#
# It will cause the variable to look like:
# @CODE
# RDEPEND="python_targets_python2_5? (
#     dev-python/unittest2[python_targets_python2_5?] )
#	python_targets_python2_6? (
#     dev-python/unittest2[python_targets_python2_6?] )"
# @CODE
python_gen_cond_dep() {
	debug-print-function ${FUNCNAME} "${@}"

	local impl pattern
	local matches=()

	local dep=${1}
	shift

	for impl in "${PYTHON_COMPAT[@]}"; do
		_python_impl_supported "${impl}" || continue

		for pattern; do
			if [[ ${impl} == ${pattern} ]]; then
				# substitute ${PYTHON_USEDEP} if used
				# (since python_gen_usedep() will not return ${PYTHON_USEDEP}
				#  the code is run at most once)
				if [[ ${dep} == *'${PYTHON_USEDEP}'* ]]; then
					local PYTHON_USEDEP=$(python_gen_usedep "${@}")
					dep=${dep//\$\{PYTHON_USEDEP\}/${PYTHON_USEDEP}}
				fi

				matches+=( "python_targets_${impl}? ( ${dep} )" )
				break
			fi
		done
	done

	echo "${matches[@]}"
}

# @ECLASS-VARIABLE: BUILD_DIR
# @DESCRIPTION:
# The current build directory. In global scope, it is supposed to
# contain an initial build directory; if unset, it defaults to ${S}.
#
# In functions run by python_foreach_impl(), the BUILD_DIR is locally
# set to an implementation-specific build directory. That path is
# created through appending a hyphen and the implementation name
# to the final component of the initial BUILD_DIR.
#
# Example value:
# @CODE
# ${WORKDIR}/foo-1.3-python2_6
# @CODE

# @FUNCTION: python_copy_sources
# @DESCRIPTION:
# Create a single copy of the package sources for each enabled Python
# implementation.
#
# The sources are always copied from initial BUILD_DIR (or S if unset)
# to implementation-specific build directory matching BUILD_DIR used by
# python_foreach_abi().
python_copy_sources() {
	debug-print-function ${FUNCNAME} "${@}"

	local MULTIBUILD_VARIANTS
	_python_obtain_impls

	multibuild_copy_sources
}

# @FUNCTION: _python_check_USE_PYTHON
# @INTERNAL
# @DESCRIPTION:
# Check whether USE_PYTHON and PYTHON_TARGETS are in sync. Output
# warnings if they are not.
_python_check_USE_PYTHON() {
	debug-print-function ${FUNCNAME} "${@}"

	if [[ ! ${_PYTHON_USE_PYTHON_CHECKED} ]]; then
		_PYTHON_USE_PYTHON_CHECKED=1

		# python-exec has profile-forced flags.
		if [[ ${CATEGORY}/${PN} == dev-lang/python-exec ]]; then
			return
		fi

		_try_eselect() {
			# The eselect solution will work only with one py2 & py3.

			local impl py2 py3 dis_py2 dis_py3
			for impl in "${PYTHON_COMPAT[@]}"; do
				_python_impl_supported "${impl}" || continue

				if use "python_targets_${impl}"; then
					case "${impl}" in
						python2_*)
							if [[ ${py2+1} ]]; then
								debug-print "${FUNCNAME}: -> more than one py2: ${py2} ${impl}"
								return 1
							fi
							py2=${impl/_/.}
							;;
						python3_4)
							debug-print "${FUNCNAME}: python3.4 found, not using eselect"
							return 1
							;;
						python3_*)
							if [[ ${py3+1} ]]; then
								debug-print "${FUNCNAME}: -> more than one py3: ${py3} ${impl}"
								return 1
							fi
							py3=${impl/_/.}
							;;
						*)
							return 1
							;;
					esac
				else
					case "${impl}" in
						python2_*)
							dis_py2=1
							;;
						python3_*)
							dis_py3=1
							;;
					esac
				fi
			done

			# The eselect solution won't work if the disabled Python version
			# is installed.
			if [[ ! ${py2+1} && ${dis_py2} ]]; then
				debug-print "${FUNCNAME}: -> all py2 versions disabled"
				if ! has python2_7 "${PYTHON_COMPAT[@]}"; then
					debug-print "${FUNCNAME}: ---> package does not support 2.7"
					return 0
				fi
				if has_version '=dev-lang/python-2*'; then
					debug-print "${FUNCNAME}: ---> but =python-2* installed!"
					return 1
				fi
			fi
			if [[ ! ${py3+1} && ${dis_py3} ]]; then
				debug-print "${FUNCNAME}: -> all py3 versions disabled"
				if ! has python3_2 "${PYTHON_COMPAT[@]}"; then
					debug-print "${FUNCNAME}: ---> package does not support 3.2"
					return 0
				fi
				if has_version '=dev-lang/python-3*'; then
					debug-print "${FUNCNAME}: ---> but =python-3* installed!"
					return 1
				fi
			fi

			local warned

			# Now check whether the correct implementations are active.
			if [[ ${py2+1} ]]; then
				local sel_py2=$(eselect python show --python2)

				debug-print "${FUNCNAME}: -> py2 built: ${py2}, active: ${sel_py2}"
				if [[ ${py2} != ${sel_py2} ]]; then
					ewarn "Building package for ${py2} only while ${sel_py2} is active."
					ewarn "Please consider switching the active Python 2 interpreter:"
					ewarn
					ewarn "	eselect python set --python2 ${py2}"
					warned=1
				fi
			fi


			if [[ ${py3+1} ]]; then
				local sel_py3=$(eselect python show --python3)

				debug-print "${FUNCNAME}: -> py3 built: ${py3}, active: ${sel_py3}"
				if [[ ${py3} != ${sel_py3} ]]; then
					[[ ${warned} ]] && ewarn
					ewarn "Building package for ${py3} only while ${sel_py3} is active."
					ewarn "Please consider switching the active Python 3 interpreter:"
					ewarn
					ewarn "	eselect python set --python3 ${py3}"
					warned=1
				fi
			fi

			if [[ ${warned} ]]; then
				ewarn
				ewarn "Please note that after switching the active Python interpreter,"
				ewarn "you may need to run 'python-updater' to rebuild affected packages."
				ewarn
				ewarn "For more information on PYTHON_TARGETS and python.eclass"
				ewarn "compatibility, please see the relevant Wiki article [1]."
				ewarn
				ewarn "[1] https://wiki.gentoo.org/wiki/Project:Python/PYTHON_TARGETS"
			fi
		}

		# If user has no USE_PYTHON, try to avoid it.
		if [[ ! ${USE_PYTHON} ]]; then
			debug-print "${FUNCNAME}: trying eselect solution ..."
			_try_eselect && return
		fi

		debug-print "${FUNCNAME}: trying USE_PYTHON solution ..."
		debug-print "${FUNCNAME}: -> USE_PYTHON=${USE_PYTHON}"

		local impl old=${USE_PYTHON} new=() removed=()

		for impl in "${PYTHON_COMPAT[@]}"; do
			_python_impl_supported "${impl}" || continue

			local abi
			case "${impl}" in
				pypy|python3_4)
					# unsupported in python.eclass
					continue
					;;
				python*)
					abi=${impl#python}
					;;
				jython*)
					abi=${impl#jython}-jython
					;;
				*)
					die "Unexpected Python implementation: ${impl}"
					;;
			esac
			abi=${abi/_/.}

			has "${abi}" ${USE_PYTHON}
			local has_abi=${?}
			use "python_targets_${impl}"
			local has_impl=${?}

			# 0 = has, 1 = does not have
			if [[ ${has_abi} == 0 && ${has_impl} == 1 ]]; then
				debug-print "${FUNCNAME}: ---> remove ${abi}"
				# remove from USE_PYTHON
				old=${old/${abi}/}
				removed+=( ${abi} )
			elif [[ ${has_abi} == 1 && ${has_impl} == 0 ]]; then
				debug-print "${FUNCNAME}: ---> add ${abi}"
				# add to USE_PYTHON
				new+=( ${abi} )
			fi
		done

		if [[ ${removed[@]} || ${new[@]} ]]; then
			old=( ${old} )

			debug-print "${FUNCNAME}: -> old: ${old[@]}"
			debug-print "${FUNCNAME}: -> new: ${new[@]}"
			debug-print "${FUNCNAME}: -> removed: ${removed[@]}"

			if [[ ${USE_PYTHON} ]]; then
				ewarn "It seems that your USE_PYTHON setting lists different Python"
				ewarn "implementations than your PYTHON_TARGETS variable. Please consider"
				ewarn "using the following value instead:"
				ewarn
				ewarn "	USE_PYTHON='\033[35m${old[@]}${new[@]+ \033[1m${new[@]}}\033[0m'"

				if [[ ${removed[@]} ]]; then
					ewarn
					ewarn "(removed \033[31m${removed[@]}\033[0m)"
				fi
			else
				ewarn "It seems that you need to set USE_PYTHON to make sure that legacy"
				ewarn "packages will be built with respect to PYTHON_TARGETS correctly:"
				ewarn
				ewarn "	USE_PYTHON='\033[35;1m${new[@]}\033[0m'"
			fi

			ewarn
			ewarn "Please note that after changing the USE_PYTHON variable, you may need"
			ewarn "to run 'python-updater' to rebuild affected packages."
			ewarn
			ewarn "For more information on PYTHON_TARGETS and python.eclass"
			ewarn "compatibility, please see the relevant Wiki article [1]."
			ewarn
			ewarn "[1] https://wiki.gentoo.org/wiki/Project:Python/PYTHON_TARGETS"
		fi
	fi
}

# @FUNCTION: _python_obtain_impls
# @INTERNAL
# @DESCRIPTION:
# Set up the enabled implementation list.
_python_obtain_impls() {
	if [[ ${PYTHON_COMPAT_OVERRIDE} ]]; then
		if [[ ! ${_PYTHON_COMPAT_OVERRIDE_WARNED} ]]; then
			ewarn "WARNING: PYTHON_COMPAT_OVERRIDE in effect. The following Python"
			ewarn "implementations will be enabled:"
			ewarn
			ewarn "	${PYTHON_COMPAT_OVERRIDE}"
			ewarn
			ewarn "Dependencies won't be satisfied, and PYTHON_TARGETS will be ignored."
			_PYTHON_COMPAT_OVERRIDE_WARNED=1
		fi

		MULTIBUILD_VARIANTS=( ${PYTHON_COMPAT_OVERRIDE} )
		return
	fi

	_python_validate_useflags
	_python_check_USE_PYTHON

	MULTIBUILD_VARIANTS=()

	for impl in "${_PYTHON_ALL_IMPLS[@]}"; do
		if has "${impl}" "${PYTHON_COMPAT[@]}" \
			&& use "python_targets_${impl}"
		then
			MULTIBUILD_VARIANTS+=( "${impl}" )
		fi
	done
}

# @FUNCTION: _python_multibuild_wrapper
# @USAGE: <command> [<args>...]
# @INTERNAL
# @DESCRIPTION:
# Initialize the environment for Python implementation selected
# for multibuild.
_python_multibuild_wrapper() {
	debug-print-function ${FUNCNAME} "${@}"

	local -x EPYTHON PYTHON
	local -x PATH=${PATH} PKG_CONFIG_PATH=${PKG_CONFIG_PATH}
	python_export "${MULTIBUILD_VARIANT}" EPYTHON PYTHON
	python_wrapper_setup

	"${@}"
}

# @FUNCTION: python_foreach_impl
# @USAGE: <command> [<args>...]
# @DESCRIPTION:
# Run the given command for each of the enabled Python implementations.
# If additional parameters are passed, they will be passed through
# to the command.
#
# The function will return 0 status if all invocations succeed.
# Otherwise, the return code from first failing invocation will
# be returned.
#
# For each command being run, EPYTHON, PYTHON and BUILD_DIR are set
# locally, and the former two are exported to the command environment.
python_foreach_impl() {
	debug-print-function ${FUNCNAME} "${@}"

	local MULTIBUILD_VARIANTS
	_python_obtain_impls

	multibuild_foreach_variant _python_multibuild_wrapper "${@}"
}

# @FUNCTION: python_parallel_foreach_impl
# @USAGE: <command> [<args>...]
# @DESCRIPTION:
# Run the given command for each of the enabled Python implementations.
# If additional parameters are passed, they will be passed through
# to the command.
#
# The function will return 0 status if all invocations succeed.
# Otherwise, the return code from first failing invocation will
# be returned.
#
# For each command being run, EPYTHON, PYTHON and BUILD_DIR are set
# locally, and the former two are exported to the command environment.
#
# Multiple invocations of the command will be run in parallel, up to
# DISTUTILS_JOBS (defaulting to '-j' option argument from MAKEOPTS).
python_parallel_foreach_impl() {
	debug-print-function ${FUNCNAME} "${@}"

	local MULTIBUILD_JOBS=${MULTIBUILD_JOBS:-${DISTUTILS_JOBS}}
	local MULTIBUILD_VARIANTS
	_python_obtain_impls
	multibuild_parallel_foreach_variant _python_multibuild_wrapper "${@}"
}

# @FUNCTION: python_setup
# @DESCRIPTION:
# Find the best (most preferred) Python implementation enabled
# and set the Python build environment up for it.
#
# This function needs to be used when Python is being called outside
# of python_foreach_impl calls (e.g. for shared processes like doc
# building). python_foreach_impl sets up the build environment itself.
python_setup() {
	debug-print-function ${FUNCNAME} "${@}"

	python_export_best
	python_wrapper_setup
}

# @FUNCTION: python_export_best
# @USAGE: [<variable>...]
# @DESCRIPTION:
# Find the best (most preferred) Python implementation enabled
# and export given variables for it. If no variables are provided,
# EPYTHON & PYTHON will be exported.
python_export_best() {
	debug-print-function ${FUNCNAME} "${@}"

	[[ ${#} -gt 0 ]] || set -- EPYTHON PYTHON

	local best MULTIBUILD_VARIANTS
	_python_obtain_impls

	_python_set_best() {
		best=${MULTIBUILD_VARIANT}
	}
	multibuild_for_best_variant _python_set_best

	debug-print "${FUNCNAME}: Best implementation is: ${best}"
	python_export "${best}" "${@}"
	python_wrapper_setup
}

# @FUNCTION: python_replicate_script
# @USAGE: <path>...
# @DESCRIPTION:
# Copy the given script to variants for all enabled Python
# implementations, then replace it with a symlink to the wrapper.
#
# All specified files must start with a 'python' shebang. A file not
# having a matching shebang will be refused.
python_replicate_script() {
	debug-print-function ${FUNCNAME} "${@}"

	_python_replicate_script() {
		local _PYTHON_FIX_SHEBANG_QUIET=1

		if _python_want_python_exec2; then
			local PYTHON_SCRIPTDIR
			python_export PYTHON_SCRIPTDIR

			(
				exeinto "${PYTHON_SCRIPTDIR#${EPREFIX}}"
				doexe "${files[@]}"
			)

			python_fix_shebang -q \
				"${files[@]/*\//${D%/}/${PYTHON_SCRIPTDIR}/}"
		else
			local f
			for f in "${files[@]}"; do
				cp -p "${f}" "${f}-${EPYTHON}" || die
			done

			python_fix_shebang -q \
				"${files[@]/%/-${EPYTHON}}"
		fi
	}

	local files=( "${@}" )
	python_foreach_impl _python_replicate_script

	# install the wrappers
	local f
	for f; do
		_python_ln_rel "${ED%/}$(_python_get_wrapper_path)" "${f}" || die
	done
}

_PYTHON_R1=1
fi
