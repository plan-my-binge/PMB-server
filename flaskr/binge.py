import os

from elasticsearch import Elasticsearch, TransportError
from flask import Flask, jsonify, request, abort
from flask_compress import Compress
from flask_cors import CORS

ELASTICSEARCH_URL = os.environ.get('ELASTICSEARCH_URL')
ELASTICSEARCH_USER = os.environ.get('ELASTICSEARCH_USER')
ELASTICSEARCH_PASSWORD = os.environ.get('ELASTICSEARCH_PASSWORD')
ELASTICSEARCH_INDEX = 'binge'
ELASTICSEARCH_DOCTYPE = 'series'

es = Elasticsearch([ELASTICSEARCH_URL],
                   http_auth=(ELASTICSEARCH_USER, ELASTICSEARCH_PASSWORD),
                   scheme='https',
                   port='9243'
                   )

app = Flask(__name__)
Compress(app)
CORS(app)

fields_of_interest = ['averageRating', 'startYear', 'endYear', 'genres', 'perEpisodeRuntime',
                      'landscapePoster', 'portraitPoster',
                      'primaryTitle', 'seasons', 'pmb_id']


@app.route('/')
def hello():
    return 'Hello, World!'


@app.route('/shows/popular')
def get_popular_shows():
    response = es.search(
        index=ELASTICSEARCH_INDEX,
        doc_type=ELASTICSEARCH_DOCTYPE,
        scroll='2m',
        size=10,
        filter_path='hits.hits._source',
        body={
            '_source': fields_of_interest,
            'query': {
                'ids': {
                    'values': [
                        'tt0386676',  # The Office
                        'tt1442437',  # Modern Family
                        'tt6468322',  # Money Heist
                        'tt0944947',  # Game of Thrones
                        'tt4574334',  # Stranger Things
                        'tt2467372',  # Brooklyn nine-nine
                        'tt0238784',  # Gilmore Girls
                        'tt3398228',  # Bojack Horseman
                    ]
                }
            }
        }
    )
    if not bool(response):
        return abort(400)

    hits = response['hits']['hits']
    return jsonify(hits)


@app.route('/shows/<show_id>')
def get_show(show_id):
    try:
        response = es.search(
            index=ELASTICSEARCH_INDEX,
            doc_type=ELASTICSEARCH_DOCTYPE,
            scroll='2m',
            size=10,
            filter_path='hits.hits._source',
            body={
                '_source': fields_of_interest,
                'query': {
                    'match': {
                        'pmb_id': show_id
                    }
                }
            }
        )
        hits = response['hits']['hits']
        return jsonify(hits)
    except TransportError as err:
        abort(404)


@app.route('/shows')
def search_show():
    query = request.args.get('q')

    try:
        response = es.search(
            index=ELASTICSEARCH_INDEX,
            doc_type=ELASTICSEARCH_DOCTYPE,
            scroll='2m',
            size=10,
            filter_path='hits.hits._source',
            body={
                '_source': fields_of_interest,
                'query': {
                    'match': {
                        'primaryTitle': query
                    }
                }
            }
        )

        if not bool(response):
            return jsonify([])

        hits = response['hits']['hits']
        return jsonify(hits)
    except TransportError as err:
        abort(400)


if __name__ == "__main__":
    app.run(host='0.0.0.0')
