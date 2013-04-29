# ruby server.rb &
shoes server.rb &
echo Server started

for i in 1 2 3
do
  shoes client.rb &
  echo Client $i started
done

shoes server.rb &
# echo Channel started
