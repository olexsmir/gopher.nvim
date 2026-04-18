package main

import "database/sql"

type SomeConn struct {
	db  *sql.DB
	dsn string `json:"dsn"`
}
