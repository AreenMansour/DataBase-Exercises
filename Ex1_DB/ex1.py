import csv
from io import TextIOWrapper
from zipfile import ZipFile

# Define the names of the CSV files for each table and their headers
table_files = {
    "film": ("film.csv", ["fid", "fname", "release_year", "time"]),
    "genre": ("genre.csv", ["gname"]),
    "genreType": ("genreType.csv", ["fid", "gname"]),
    "content_rating": ("content_rating.csv", ["type"]),
    "rated": ("rated.csv", ["fid", "type"]),
    "person": ("person.csv", ["person_name"]),
    "Director": ("Director.csv", ["person_name"]),
    "Author": ("Author.csv", ["person_name"]),
    "Actor": ("Actor.csv", ["person_name"]),
    "award": ("award.csv", ["year"]),
    "candidate": ("candidate.csv", ["fid", "year"]),
    "win": ("win.csv", ["fid", "year"]),
    "studio": ("studio.csv", ["sname"]),
    "produced": ("produced.csv", ["fid", "sname"]),
    "directed": ("directed.csv", ["fid", "person_name"]),
    "wrote": ("wrote.csv", ["fid", "person_name"]),
    "acted": ("acted.csv", ["fid", "person_name"]),
    "IMDB": ("IMDB.csv", ["fid", "IMDBRating", "IMDBVotes"]),
}

# Open files for writing for each table
table_writers = {table: open(filename, 'w', encoding='UTF8', newline='') for table, (filename, _) in
                 table_files.items()}
table_csv_writers = {table: csv.writer(file, delimiter=",", quoting=csv.QUOTE_MINIMAL) for table, file in
                     table_writers.items()}

# Write headers to each CSV file
for table, (filename, headers) in table_files.items():
    table_csv_writers[table].writerow(headers)

# Sets to keep track of unique values
unique_genres = set()
unique_genre_types = set()
unique_content_ratings = set()
unique_studios = set()
unique_produced = set()
unique_awards = set()
unique_candidates = set()
unique_wins = {}
unique_rated = set()
unique_persons = set()
unique_directors = set()
unique_actors = set()
unique_authors = set()
# Function to split values in a list by "&&"
def split_list_value(list_value):
    return list_value.split("&&")


# Process the file
def process_file():
    with ZipFile('oscars.zip') as zf:
        with zf.open('oscars.csv', 'r') as infile:
            reader = csv.reader(TextIOWrapper(infile, 'utf-8'))
            next(reader)  # Skip header row if necessary
            for row in reader:
                process_row(row)

    # Write unique content ratings to the content_rating table
    for rating in unique_content_ratings:
        content_rating_row = [rating]
        table_csv_writers['content_rating'].writerow(content_rating_row)

    # Write unique person names to the person table
    for person_name in unique_persons:
        person_row = [person_name]
        table_csv_writers['person'].writerow(person_row)
    close_files()


# Process each row and write to the corresponding CSV file
def process_row(row):
    film_row = [row[14], row[1], row[5], row[6]]
    table_csv_writers['film'].writerow(film_row)


    directors = split_list_value(row[11])
    if directors:
        for director in directors:
            if director and director not in unique_directors:
                unique_directors.add(director)
                unique_persons.add(director)
                director_row = [director]
                table_csv_writers['Director'].writerow(director_row)
                directed_row = [row[14], director]
                table_csv_writers['directed'].writerow(directed_row)

    actors = split_list_value(row[13])
    for actor in actors:
        if actor and actor not in unique_actors:
            unique_actors.add(actor)
            unique_persons.add(actor)
            actor_row = [actor]
            table_csv_writers['Actor'].writerow(actor_row)
            acted_row = [row[14], actor]
            table_csv_writers['acted'].writerow(acted_row)

    authors = split_list_value(row[12])
    for author in authors:
        if author and author not in unique_authors:
            unique_authors.add(author)
            unique_persons.add(author)
            author_row = [author]
            table_csv_writers['Author'].writerow(author_row)
            wrote_row = [row[14], author]
            table_csv_writers['wrote'].writerow(wrote_row)

    genres = split_list_value(row[7])
    for genre in genres:
        normalized_genre = genre
        if normalized_genre not in unique_genres:
            unique_genres.add(normalized_genre)
            genre_row = [normalized_genre]
            table_csv_writers['genre'].writerow(genre_row)
        genre_type_key = (row[14], normalized_genre)
        if genre_type_key not in unique_genre_types:
            unique_genre_types.add(genre_type_key)
            genre_type_row = [row[14], normalized_genre]
            table_csv_writers['genreType'].writerow(genre_type_row)

    candidate_key = (row[14], row[2])
    if candidate_key not in unique_candidates:
        unique_candidates.add(candidate_key)
        candidate_row = [row[14], row[2]]
        table_csv_writers['candidate'].writerow(candidate_row)

    award_key = row[2]
    if award_key not in unique_awards:
        unique_awards.add(award_key)
        award_row = [row[2]]
        table_csv_writers['award'].writerow(award_row)

    studio_key = row[3]
    if studio_key not in unique_studios:
        unique_studios.add(studio_key)
        studio_row = [row[3]]
        table_csv_writers['studio'].writerow(studio_row)
    produced_key = (row[14], row[3])
    if produced_key not in unique_produced:
        unique_produced.add(produced_key)
        produced_row = [row[14], row[3]]
        table_csv_writers['produced'].writerow(produced_row)

    imdb_row = [row[14], row[8], row[9]]
    table_csv_writers['IMDB'].writerow(imdb_row)

    # Track unique wins by year
    year = row[2]
    if year not in unique_wins:
        unique_wins[year] = row[14]
        win_row = [row[14], year]
        table_csv_writers['win'].writerow(win_row)

    # Process content rating
    content_rating = row[10].strip()
    if content_rating and content_rating not in unique_content_ratings:
        unique_content_ratings.add(content_rating)
    if content_rating:
        rated_row = [row[14], content_rating]
        table_csv_writers['rated'].writerow(rated_row)


# Close all CSV file

def close_files():
    for file in table_writers.values():
        file.close()


# Return the list of all tables
def get_names():
    return list(table_files.keys())


if __name__ == "__main__":
    process_file()
