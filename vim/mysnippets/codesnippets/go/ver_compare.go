package util

import (
	"sort"
	"strconv"
	"strings"
)

// CompareVer compare a version with b version, return -1 if a newer than b
func CompareVer(a, b string) (ret int) {
	as := strings.Split(a, ".")
	bs := strings.Split(b, ".")
	loopMax := len(bs)
	if len(as) > len(bs) {
		loopMax = len(as)
	}
	for i := 0; i < loopMax; i++ {
		var x, y string
		if len(as) > i {
			x = as[i]
		}
		if len(bs) > i {
			y = bs[i]
		}
		xi, _ := strconv.Atoi(x)
		yi, _ := strconv.Atoi(y)
		if xi > yi {
			ret = 1
		} else if xi < yi {
			ret = -1
		}
		if ret != 0 {
			break
		}
	}
	return
}

type VersionSlice []string

func (p VersionSlice) Len() int           { return len(p) }
func (p VersionSlice) Less(i, j int) bool { return CompareVer(p[i], p[j]) < 0 }
func (p VersionSlice) Swap(i, j int)      { p[i], p[j] = p[j], p[i] }

// Sort is a convenience method.
func (p VersionSlice) Sort() { sort.Sort(p) }
