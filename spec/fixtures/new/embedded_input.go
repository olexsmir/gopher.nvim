package main

import (
	"database/sql"
	"sync"
)

type Store struct {
	sync.Mutex
	db *sql.DB
}
