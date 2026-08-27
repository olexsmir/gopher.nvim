package main

import "database/sql"

type SomeConn struct {
	db  *sql.DB
	dsn string `json:"dsn"`
}

func NewSomeConn(db *sql.DB, dsn string) SomeConn {
	return SomeConn{
		db:  db,
		dsn: dsn,
	}
}
