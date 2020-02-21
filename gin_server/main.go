package main

import (
	"database/sql"
	"fmt"
	"log"
	"net/http"

	"github.com/gin-gonic/gin"
	_ "github.com/go-sql-driver/mysql"
)

type Person struct {
	Id        int    `json:"id" form:"id"`
	FirstName string `json:"first_name" form:"first_name"`
	LastName  string `json:"last_name" form:"last_name"`
}

func main() {

	db, err := sql.Open("mysql", "root:0090@tcp(127.0.0.1:3306)/test?parseTime=true")
	if err != nil {
		log.Fatalln(err)
	}
	defer db.Close()

	db.SetMaxIdleConns(20)
	db.SetMaxOpenConns(20)

	if err := db.Ping(); err != nil {
		log.Fatalln(err)
	}

	router := gin.Default()
	router.GET("/", func(c *gin.Context) {
		c.String(http.StatusOK, "works")
	})

	router.GET("/persons", func(c *gin.Context) {
		rows, err := db.Query("SELECT id, first_name, last_name FROM person")

		if err != nil {
			log.Fatalln(err)
		}
		defer rows.Close()

		persons := make([]Person, 0)

		for rows.Next() {
			var person Person
			rows.Scan(&person.Id, &person.FirstName, &person.LastName)
			persons = append(persons, person)
		}
		if err = rows.Err(); err != nil {
			log.Fatalln(err)
		}

		c.JSON(http.StatusOK, gin.H{
			"persons": persons,
		})

	})

	router.GET("/person/:id", func(c *gin.Context) {
		id := c.Param("id")
		var person Person
		err := db.QueryRow("SELECT id, first_name, last_name FROM person WHERE id=?", id).Scan(
			&person.Id, &person.FirstName, &person.LastName,
		)
		if err != nil {
			log.Println(err)
			c.JSON(http.StatusOK, gin.H{
				"person": nil,
			})
			return
		}

		c.JSON(http.StatusOK, gin.H{
			"person": person,
		})

	})
	//curl -X POST http://127.0.0.1:8000/person -d "first_name=hello&last_name=world"
	router.POST("/person", func(c *gin.Context) {
		firstName := c.Request.FormValue("first_name")
		lastName := c.Request.FormValue("last_name")

		rs, err := db.Exec("INSERT INTO person(first_name, last_name) VALUES (?, ?)", firstName, lastName)
		if err != nil {
			log.Fatalln(err)
		}

		id, err := rs.LastInsertId()
		if err != nil {
			log.Fatalln(err)
		}
		fmt.Println("insert person Id {}", id)
		msg := fmt.Sprintf("insert successful %d", id)
		c.JSON(http.StatusOK, gin.H{
			"msg": msg,
		})
	})

	router.Run(":8000")
}
