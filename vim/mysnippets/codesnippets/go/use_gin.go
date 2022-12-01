package main

import (
	"context"
	"fmt"
	"log"
	"net/http"
	"os"
	"os/signal"
	"time"

	"github.com/gin-gonic/gin"
)

func main() {
	// https://gin-gonic.com/docs/examples/
	// gin.SetMode(gin.ReleaseMode)
	gin.DisableConsoleColor()

	r := gin.New()
	r.Use(gin.Logger())
	r.Use(gin.Recovery())
	// r.Static("/assets", "./assets")
	// r.StaticFS("/static", gin.Dir(staticDir, false))

	// Logging to a file.
	// f, _ := os.Create("gin.log")
	// gin.DefaultWriter = io.MultiWriter(f)

	// Use the following code if you need to write the logs to file and console at the same time.
	// gin.DefaultWriter = io.MultiWriter(f, os.Stdout)

	r.GET("/", func(c *gin.Context) {
		c.String(200, "SMS server works.")
	})

	r.GET("/someJSON", func(c *gin.Context) {
		// c.PureJSON(200, gin.H{
		// 	"html": "<b>Hello, world!</b>",
		// })
		// c.AsciiJSON(http.StatusOK, data)
		c.JSON(http.StatusOK, gin.H{"message": "hey", "status": http.StatusOK})
	})

	r.POST("/bindpost", func(c *gin.Context) {
		// var person Person
		// if c.ShouldBind(&person) == nil {
		// 	log.Println(person.Name)
		// 	log.Println(person.Address)
		// 	log.Println(person.Birthday)
		// }
	})
	r.POST("/post", func(c *gin.Context) {
		id := c.Query("id")
		page := c.DefaultQuery("page", "0")
		name := c.PostForm("name")
		message := c.PostForm("message")
		fmt.Printf("id: %s; page: %s; name: %s; message: %s", id, page, name, message)
	})

	r.GET("/:name/:id", func(c *gin.Context) {
		// name := c.Param("name")
		type Person struct {
			ID   string `uri:"id" binding:"required,uuid"`
			Name string `uri:"name" binding:"required"`
		}
		var person Person
		if err := c.ShouldBindUri(&person); err != nil {
			c.JSON(400, gin.H{"msg": err})
			return
		}
		c.JSON(200, gin.H{"name": person.Name, "uuid": person.ID})
	})

	// authorized := r.Group("/", AuthRequired)
	{
		// authorized.POST("/send", sendHandler)
		// authorized.GET("/log", sendLogHandler)
	}

	srv := &http.Server{
		Handler:        r,
		Addr:           "0.0.0.0:8080",
		WriteTimeout:   10 * time.Second,
		ReadTimeout:    10 * time.Second,
		MaxHeaderBytes: 1 << 10,
	}

	// Run our server in a goroutine so that it doesn't block.
	go func() {
		log.Printf("server listening on %s\n", srv.Addr)
		if err := srv.ListenAndServe(); err != http.ErrServerClosed {
			log.Fatal(err)
		}
	}()

	// We'll accept graceful shutdowns when quit via SIGINT (Ctrl+C)
	// SIGKILL, SIGQUIT or SIGTERM (Ctrl+/) will not be caught.
	c := make(chan os.Signal, 1)
	signal.Notify(c, os.Interrupt)
	<-c

	// Create a deadline to wait for.
	ctx, cancel := context.WithTimeout(context.Background(), time.Second*10)
	defer cancel()
	if err := srv.Shutdown(ctx); err != nil {
		log.Fatal("Server Shutdown:", err)
	}

	log.Println("Server exiting")
	os.Exit(0)
}
