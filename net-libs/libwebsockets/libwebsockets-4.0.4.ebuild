# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="A flexible pure-C library for implementing network protocols"
HOMEPAGE="https://libwebsockets.org/"
SRC_URI="https://github.com/warmcat/libwebsockets/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/16" # libwebsockets.so.16
KEYWORDS="~amd64 ~arm ~x86"
IUSE="access-log caps cgi client dbus +dir +extensions +file-ops generic-sessions http-proxy +http-uncommon-headers http2 ipv6
	+lejp libev libevent libressl libuv mbedtls peer-limits server-status smtp socks5
	sqlite3 ssl static-libs +testapps threads zip"

REQUIRED_USE="
	generic-sessions? ( smtp sqlite3 )
	http-proxy? ( client )
	smtp? ( libuv )
	ssl? ( ?? ( libressl mbedtls ) )
	testapps? ( extensions )
	?? ( libev libevent )
"

RDEPEND="
	sys-libs/zlib
	caps? ( sys-libs/libcap )
	http-proxy? ( net-libs/libhubbub )
	libev? ( dev-libs/libev )
	libevent? ( dev-libs/libevent:= )
	libuv? ( dev-libs/libuv:= )
	sqlite3? ( dev-db/sqlite:= )
	ssl? (
		!libressl? (
			!mbedtls? ( dev-libs/openssl:0= )
			mbedtls? ( >net-libs/mbedtls-2.0.0 )
			)
		)"

DEPEND="${RDEPEND}"
BDEPEND="dev-lang/perl"

PATCHES=(
	"${FILESDIR}/libwebsockets-3.2.0-check_chown_result.patch"
)

src_configure() {
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_Git=ON
		-DLWS_HAVE_LIBCAP=$(usex caps)
		-DLWS_HAVE_SYS_CAPABILITY_H=$(usex caps)
		-DLWS_IPV6=$(usex ipv6)
		-DLWS_LINK_TESTAPPS_DYNAMIC=$(usex testapps)
		-DLWS_ROLE_DBUS=$(usex dbus)
		-DLWS_WITHOUT_CLIENT=$(usex !client)
		-DLWS_WITHOUT_TEST_CLIENT=$(usex !client)
		-DLWS_WITH_ACCESS_LOG=$(usex access-log)
		-DLWS_WITH_CGI=$(usex cgi)
		-DLWS_WITH_DIR=$(usex dir)
		-DLWS_WITHOUT_EXTENSIONS=$(usex !extensions)
		-DLWS_WITH_FILE_OPS=$(usex file-ops)
		-DLWS_WITH_GENERIC_SESSIONS=$(usex generic-sessions)
		-DLWS_WITH_HTTP2=$(usex http2)
		-DLWS_WITH_HTTP_BASIC_AUTH=$(usex http-uncommon-headers)
		-DLWS_WITH_HTTP_PROXY=$(usex http-proxy)
		-DLWS_WITH_HTTP_UNCOMMON_HEADERS=$(usex http-uncommon-headers)
		-DLWS_WITH_HUBBUB=$(usex http-proxy)
		-DLWS_WITH_LEJP=$(usex lejp)
		-DLWS_WITH_LIBEV=$(usex libev)
		-DLWS_WITH_LIBEVENT=$(usex libevent)
		-DLWS_WITH_LIBUV=$(usex libuv)
		-DLWS_WITH_MBEDTLS=$(usex mbedtls)
		-DLWS_WITH_PEER_LIMITS=$(usex peer-limits)
		-DLWS_WITH_SERVER_STATUS=$(usex server-status)
		-DLWS_WITH_SMTP=$(usex smtp)
		-DLWS_WITH_SOCKS5=$(usex socks5)
		-DLWS_WITH_SQLITE3=$(usex sqlite3)
		-DLWS_WITH_SSL=$(usex ssl)
		-DLWS_WITH_STATIC=$(usex static-libs)
		-DLWS_WITH_THREADPOOL=$(usex threads)
		-DLWS_WITH_ZIP_FOPS=$(usex zip)
		-DLWS_WITHOUT_TESTAPPS=$(usex !testapps)
	)

	cmake_src_configure
}