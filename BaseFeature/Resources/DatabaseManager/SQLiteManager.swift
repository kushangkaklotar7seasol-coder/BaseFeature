//
//  SQLiteManager.swift
//  Korvani
//
//  Created by Kushang kaklotar on 16/07/26.
//
import Foundation
import SQLite3

final class SQLiteManager {

    static let shared = SQLiteManager()

    private var db: OpaquePointer?

    private init() {
        openDatabase()
        createTable()
    }

    deinit {
        sqlite3_close(db)
    }

    // MARK: - Open Database

    private func openDatabase() {

        let url = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("Movies.sqlite")

        print("Database Path:")
        print(url.path)

        if sqlite3_open(url.path, &db) == SQLITE_OK {
            print("Database opened")
        } else {
            print("Unable to open database")
            print(String(cString: sqlite3_errmsg(db)))
        }
    }

    // MARK: - Create Table

    private func createTable() {

        let query = """
        CREATE TABLE IF NOT EXISTS LikedMovies(
            id INTEGER PRIMARY KEY,
            title TEXT NOT NULL,
            posterPath TEXT,
            releaseDate TEXT,
            voteAverage REAL,
            isMovie INTEGER NOT NULL
        );
        """

        if sqlite3_exec(db, query, nil, nil, nil) == SQLITE_OK {
            print("Table Created")
        } else {
            print("Table Creation Failed")
            print(String(cString: sqlite3_errmsg(db)))
        }
    }

    // MARK: - Add Movie

//    func addMovie(_ movie: MediaItem) {
//
//        let query = """
//        INSERT OR REPLACE INTO LikedMovies
//        (id,title,posterPath,releaseDate,voteAverage,isMovie)
//        VALUES(?,?,?,?,?,?)
//        """
//
//        var statement: OpaquePointer?
//
//        guard sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK else {
//            print(String(cString: sqlite3_errmsg(db)))
//            return
//        }
//
//        let title = movie.title ?? movie.name ?? ""
//        let releaseDate = movie.releaseDate ?? movie.firstAirDate ?? ""
//        let poster = movie.posterPath ?? ""
//        let isMovie = movie.title != nil ? 1 : 0
//
//        sqlite3_bind_int(statement, 1, Int32(movie.id))
//        sqlite3_bind_text(statement, 2, (title as NSString).utf8String, -1, nil)
//        sqlite3_bind_text(statement, 3, (poster as NSString).utf8String, -1, nil)
//        sqlite3_bind_text(statement, 4, (releaseDate as NSString).utf8String, -1, nil)
//        sqlite3_bind_double(statement, 5, movie.voteAverage)
//        sqlite3_bind_int(statement, 6, Int32(isMovie))
//
//        if sqlite3_step(statement) == SQLITE_DONE {
//            print("Movie Saved")
//        } else {
//            print("Insert Failed")
//            print(String(cString: sqlite3_errmsg(db)))
//        }
//
//        sqlite3_finalize(statement)
//    }

    // MARK: - Delete Movie

    func removeMovie(id: Int) {

        let query = "DELETE FROM LikedMovies WHERE id = ?"

        var statement: OpaquePointer?

        guard sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK else {
            return
        }

        sqlite3_bind_int(statement, 1, Int32(id))

        if sqlite3_step(statement) == SQLITE_DONE {
            print("Movie Deleted")
        }

        sqlite3_finalize(statement)
    }

    // MARK: - Fetch Movies

//    func fetchMovies() -> [MediaItem] {
//
//        let query = """
//        SELECT
//            id,
//            title,
//            posterPath,
//            releaseDate,
//            voteAverage,
//            isMovie
//        FROM LikedMovies
//        ORDER BY id DESC
//        """
//
//        var statement: OpaquePointer?
//        var movies: [MediaItem] = []
//
//        guard sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK else {
//            print(String(cString: sqlite3_errmsg(db)))
//            return movies
//        }
//
//        while sqlite3_step(statement) == SQLITE_ROW {
//
//            let id = Int(sqlite3_column_int(statement, 0))
//
//            let title = sqlite3_column_text(statement, 1).map {
//                String(cString: $0)
//            } ?? ""
//
//            let posterPath = sqlite3_column_text(statement, 2).map {
//                String(cString: $0)
//            }
//
//            let releaseDate = sqlite3_column_text(statement, 3).map {
//                String(cString: $0)
//            } ?? ""
//
//            let voteAverage = sqlite3_column_double(statement, 4)
//
//            let isMovie = Int(sqlite3_column_int(statement, 5))
//
//            let item = MediaItem(
//                adult: false,
//                backdropPath: nil,
//                genreIds: [],
//                id: id,
//                originalLanguage: "",
//                overview: "",
//                popularity: 0,
//                posterPath: posterPath,
//                softcore: false,
//                voteAverage: voteAverage,
//                voteCount: 0,
//                title: isMovie == 1 ? title : nil,
//                originalTitle: "",
//                releaseDate: isMovie == 1 ? releaseDate : nil,
//                video: false,
//                name: isMovie == 0 ? title : nil,
//                originalName: "",
//                firstAirDate: isMovie == 0 ? releaseDate : nil,
//                originCountry: [],
//                character: "",
//                creditId: "",
//                episodeCount: 0,
//                firstCreditAirDate: "",
//                isMovie: isMovie
//            )
//
//            movies.append(item)
//        }
//
//        sqlite3_finalize(statement)
//
//        return movies
//    }

    // MARK: - Check Like

    func isMovieLiked(id: Int) -> Bool {

        let query = "SELECT 1 FROM LikedMovies WHERE id = ? LIMIT 1"

        var statement: OpaquePointer?

        guard sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK else {
            return false
        }

        sqlite3_bind_int(statement, 1, Int32(id))

        let exists = sqlite3_step(statement) == SQLITE_ROW

        sqlite3_finalize(statement)

        return exists
    }
}
