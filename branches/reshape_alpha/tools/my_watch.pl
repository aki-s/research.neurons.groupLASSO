#!/usr/bin/perl 
##cite: http://d.hatena.ne.jp/snsn9pan/20070812/1186795099
### NO WARRANTY, NO COPYRIGHT! ###
# $Id$
# Usage: perl makeauto.pl [-n<second>] [-d=no] [-e="<source>"] <files>

### HELP BEGIN ###################
# 使用法: perl makeauto.pl [オプション]... <ファイル>...
# ファイルの更新を見張って、更新されたらmakeを行う
# 
# オプション#       -n<seconds>             make間隔を指定する(初期値:2)
#       -d=no                           makeするディレクトリを移動しない
#       -e="<source>"           監視実行コマンドの指定(make以外も指定可能)
#                                               ※特定の文字列を置き換えます
#                                                       %f : 更新ファイル
#
# 使用例:
#  $ perl makeauto.pl -n1 *.[ch] 
#  $ perl tools/my_watch.pl -n 10 -d=no -e="tools/my_sync.sh" outdir/fig/masterT/*.{eps,png,jpeg}
### HELP END #####################

use strict;

use Cwd;
my $cwd = Cwd::getcwd();

#:---------------------------------------:#
#option
my $op_sec=2;
my $op_dir=1;
my $op_src="make; make tag > /dev/null;";

#:---------------------------------------:#
#file listner 
my %up;
my %cur;

#:---------------------------------------:#
#args check
my @files=();
foreach (@ARGV){
    #option -null        
    if ( /^\-n(\d+)/ )
    { $op_sec = $1; next; }

    #option -d 
    if ( /^\-d\=no/ )
    { $op_dir = 0; next; }

    #option -END   
    if ( /^\-e\=(.*)/ )
    { $op_src = $1; next; }

    $up{$_} = $cur{$_} = (stat $_)[9];
    @files = (@files, $_);
}
&usage("missing files") if ( @files == 0 );


print "auto command: $op_src.\n";
#:---------------------------------------:#
#main loop
while (1) {
    foreach my $fn (@files){
	#print "$fn: ".$cur{$fn}."=".$up{$fn}."\n";

	$cur{$fn} = (stat $fn)[9];      # 監視対象ファイルの更新時間
	#print "$up $cur\n";    # for debug
	if ($up{$fn} != $cur{$fn}) {
	    my @dir = split /\//, $fn;
	    if ( -d @dir[0] and $op_dir )
	    {
		pop(@dir); #remove files 
		my $dir="";
		foreach( @dir )
		{ $dir .= "$_/"; }

		chdir $dir;
		#print "\n\n$dir\n\n";
	    }
	    
	    ### 対象ファイルがアップデートされたときに行う処理
	    # ここから
	    print "$fn: ============ UPDATE ============\n";

	    my $src = $op_src;
	    $src =~ s/\%f/$fn/;
	    system($src);
	    # ここまで

	    chdir $cwd;
	    $up{$fn} = $cur{$fn} = (stat $fn)[9];
	    #print "test=".$up{$fn}." fn=$fn\n";
	}
    }
    sleep $op_sec;                  # 監視間隔
}


#:---------------------------------------:#
#exit program with warrn and usage
sub usage(){
    my $err = shift;
    print "Warrn: $err.\n";
    system("grep '^# Usage:' ".__FILE__." | sed 's/# //'");
    exit(0);
}
