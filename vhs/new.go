package demos

import (
	"database/sql"
	"sync"
)

type MyPostgresConn struct {
	db  *sql.DB
	dsn string
}

type IHaveGenerics[T any, F int32 | float32] struct {
	Anything   T
	IntOrFloat F
}

type SomeEmbeddedValue struct {
	sync.Mutex // dont do this please, never
	someValue  string
}
