# User specific aliases and functions
export _JAVA_OPTIONS=-Djava.security.egd=file:/dev/./urandom

export COBDIR=
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$COBDIR/lib
export PATH=$PATH:$COBDIR/bin

export TNS_ADMIN=/app/psoft/db
export ORACLE_HOME=/app/psoft/db/oracle-server/19.3.0.0
export LD_LIBRARY_PATH=$ORACLE_HOME/lib:$LD_LIBRARY_PATH
export PATH=.:$ORACLE_HOME/bin:$ORACLE_HOME/OPatch:$ORACLE_HOME/perl/bin:$PATH

TUXDIR=/app/psoft/pt/bea/tuxedo
if [ -d $TUXDIR ]; then
  export TUXDIR=$TUXDIR/tuxedo12.2.2.0.0
  export PATH=$TUXDIR/bin:$PATH
  export LD_LIBRARY_PATH=$TUXDIR/bin:$TUXDIR/lib:$LD_LIBRARY_PATH
fi

export PATH=/app/psoft/pt/ps_home8.60.05/appserv:/app/psoft/pt/ps_home8.60.05/setup:$PATH

export LANG=C
if [ -d /app/psoft/pt/ps_home8.60.05 ]; then
CWD=$PWD
cd /app/psoft/pt/ps_home8.60.05 && . ./psconfig.sh
cd $CWD
fi
export PS_CFG_HOME=/app/psoft/psconfig
export PS_APP_HOME=/app/psoft/pt/hcm_app_home
if [ -f '/app/psoft/pt/ps_home8.60.05/openssl/CA/openssl.cnf' ]; then
   export OPENSSL_CONF=/app/psoft/pt/ps_home8.60.05/openssl/CA/openssl.cnf
fi