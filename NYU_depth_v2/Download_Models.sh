mkdir ../deeplab_NYU/NYUdepth/model
mkdir ../deeplab_NYU/NYUdepth/model/resnet
mkdir ../deeplab_NYU/NYUdepth/model/resnet/trained_model

wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1EbOFo6rYSqdpqN8UpXXQ9os-inu_LFDA' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1EbOFo6rYSqdpqN8UpXXQ9os-inu_LFDA" -O ../deeplab_NYU/NYUdepth/model/resnet/init.caffemodel && rm -rf /tmp/cookies.txt

wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1wQYuWFCnOQ6fluNWYW9p_5XCx1nkbprx' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1wQYuWFCnOQ6fluNWYW9p_5XCx1nkbprx" -O ../deeplab_NYU/NYUdepth/model/resnet/trained_model/trained_iter_20000.caffemodel && rm -rf /tmp/cookies.txt

