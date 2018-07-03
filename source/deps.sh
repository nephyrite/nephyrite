#!/usr/bin/env bash

function use_deps {
	cd "$0" ;}
function use_coreutils {
	if [[ `uname` == 'Darwin' ]]; then
		[ -d "/usr/local/opt/coreutils/libexec/gnubin" ] || {
			echo "coreutils not found"
			return 1 
		} && PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH" ;fi }
function use_node {
	use_node_bare || {
		return 1 
	} && if [ -f "$(dirname $(npm root))/package.json" ]; then
		[ -d "$(npm root)" ] || {
			#TODO: does not cover case of empty dependencies
			echo "node modules not installed"
			return 1 ;} fi ;}
function use_node_bare {
	. ~/.nvm/nvm.sh --no-use
	nvm use 10 > /dev/null
	[[ "$(node --version)" == "v10"* ]] || {
		echo "couldn't change to node v10"
		return 1 ;} }
function use_file {
	[ -f "$1" ] || {
		echo "$1 doesn't exist"
		return 1 ;} }

function find_project_root {
	_pwd="$(pwd)"
	cd "$(dirname "${0}")"
	git rev-parse --show-toplevel || {
		echo "failed to find project root"
		echo "is git installed?"
		return 1 ;}
	cd "$_pwd" ;} 
function find_temp_path {
	use_coreutils && tmp_path="$temp/$(date +%s)" && [ ! -e "$tmp_path" ] && {
		echo "$tmp_path"
	} || {
		echo "failed to find temp path"
		exit 1 ;} }

function fail {
	eval $@
	exit 1 ;}

pwd="$(pwd)"
root="$(find_project_root || exit)"
temp="$root/temp"
