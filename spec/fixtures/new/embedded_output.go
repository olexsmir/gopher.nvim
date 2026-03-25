package main

import (
	"database/sql"
	"sync"
)

type Store struct {
	sync.Mutex
	db *sql.DB
}

func NewStore(db *sql.DB) Store {
	return Store{
		db: db,
	}
}
