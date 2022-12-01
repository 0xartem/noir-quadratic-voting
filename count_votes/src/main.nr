// https://gist.github.com/joss-aztec/559765f1c18cab97974737fb7ccf8132
// https://gist.github.com/joss-aztec/9f2d0900d464393a5bf4313da6804c36
// Ballot Manager Circuit
// https://github.com/joss-aztec/quadratic_voting_noir

use dep::std;

global CANDIDATE_COUNT = 10;
global VOTER_COUNT = 2;

fn sum_votes(all_votes: [u32; CANDIDATE_COUNT * VOTER_COUNT]) -> [u32; CANDIDATE_COUNT] {
    let mut totals = [0; CANDIDATE_COUNT];
    
    for i in 0..VOTER_COUNT {
        for j in 0..CANDIDATE_COUNT {
            totals[j] = totals[j] + all_votes[i * CANDIDATE_COUNT + j];
        }
    };
    totals
}

fn check_commitments(
    commitments: [Field; VOTER_COUNT],
    secrets: [Field; VOTER_COUNT],
    all_votes: [u32; VOTER_COUNT * CANDIDATE_COUNT],
) {
    for i in 0..VOTER_COUNT {
        let mut transcript = [0; CANDIDATE_COUNT + 1];
        transcript[0] = secrets[i];
        for j in 0..CANDIDATE_COUNT {
            transcript[j + 1] = all_votes[i * CANDIDATE_COUNT + j] as Field;
        };
        constrain commitments[i] == std::hash::pedersen(transcript)[0];
    };
}


fn main(
    commitments: pub [Field; VOTER_COUNT],
    all_votes: [u32; VOTER_COUNT * CANDIDATE_COUNT],
    secrets: [Field; VOTER_COUNT],
) -> pub [u32; CANDIDATE_COUNT] {
    check_commitments(commitments, secrets, all_votes);
    sum_votes(all_votes)
}